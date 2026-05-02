//
//  LocationViewModel.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/11/26.
//

import Foundation
import Combine
import MapKit
import CoreLocation

@MainActor
final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var places: [Place] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedCategory: String = "All"

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var userCoordinate: CLLocationCoordinate2D?

    let categoryOptions = ["All", "Parks", "Libraries", "Fitness"]

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        } else if manager.authorizationStatus == .denied {
            errorMessage = "Location permission was denied."
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let coordinate = location.coordinate
        userCoordinate = coordinate

        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )

        fetchNearbyGrowthPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude)

        manager.stopUpdatingLocation()
    }

    func filteredPlaces() -> [Place] {
        if selectedCategory == "Parks" {
            return places.filter { $0.category == "park" }
        } else if selectedCategory == "Libraries" {
            return places.filter { $0.category == "library" }
        } else if selectedCategory == "Fitness" {
            return places.filter { $0.category == "fitness" }
        } else {
            return places
        }
    }

    func fetchNearbyGrowthPlaces(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = ""

        let radius = 5000

        let query = """
        [out:json];
        (
          node["leisure"="park"](around:\(radius),\(latitude),\(longitude));
          way["leisure"="park"](around:\(radius),\(latitude),\(longitude));
          node["amenity"="library"](around:\(radius),\(latitude),\(longitude));
          way["amenity"="library"](around:\(radius),\(latitude),\(longitude));
          node["leisure"="fitness_centre"](around:\(radius),\(latitude),\(longitude));
          way["leisure"="fitness_centre"](around:\(radius),\(latitude),\(longitude));
        );
        out center 20;
        """

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://overpass-api.de/api/interpreter?data=\(encodedQuery)") else {
            isLoading = false
            errorMessage = "Invalid API URL."
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                Task { @MainActor in
                    self.isLoading = false
                    self.errorMessage = "API error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                Task { @MainActor in
                    self.isLoading = false
                    self.errorMessage = "No data returned from API."
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(OverpassResponse.self, from: data)
                let convertedPlaces = self.convertElementsToPlaces(decoded.elements)

                Task { @MainActor in
                    self.isLoading = false
                    self.places = Array(convertedPlaces.prefix(20))

                    if self.places.isEmpty {
                        self.errorMessage = "No nearby growth places found."
                    }
                }
            } catch {
                Task { @MainActor in
                    self.isLoading = false
                    self.errorMessage = "JSON decode error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    private func convertElementsToPlaces(_ elements: [OverpassElement]) -> [Place] {
        var results: [Place] = []

        for element in elements {
            let latitude = element.lat ?? element.center?.lat
            let longitude = element.lon ?? element.center?.lon

            guard let latitude, let longitude else {
                continue
            }

            let category = getCategory(from: element.tags)
            let name = element.tags?.name ?? defaultName(for: category)

            let place = Place(
                id: element.id,
                name: name,
                category: category,
                latitude: latitude,
                longitude: longitude
            )

            results.append(place)
        }

        return results
    }

    private func getCategory(from tags: OverpassTags?) -> String {
        if tags?.amenity == "library" {
            return "library"
        } else if tags?.leisure == "fitness_centre" {
            return "fitness"
        } else if tags?.leisure == "park" {
            return "park"
        } else {
            return "place"
        }
    }

    private func defaultName(for category: String) -> String {
        if category == "park" {
            return "Unnamed Park"
        } else if category == "library" {
            return "Unnamed Library"
        } else if category == "fitness" {
            return "Unnamed Fitness Center"
        } else {
            return "Unnamed Place"
        }
    }
}
