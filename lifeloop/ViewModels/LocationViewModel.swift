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

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var userCoordinate: CLLocationCoordinate2D?

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
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )

        fetchNearbyPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude)

        manager.stopUpdatingLocation()
    }

    func fetchNearbyPlaces(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = ""

        let north = latitude + 0.4
        let south = latitude - 0.4
        let east = longitude + 0.4
        let west = longitude - 0.4

        let urlString = "http://api.geonames.org/citiesJSON?north=\(north)&south=\(south)&east=\(east)&west=\(west)&lang=en&maxRows=10&username=yuvambh"

        guard let url = URL(string: urlString) else {
            isLoading = false
            errorMessage = "Invalid URL."
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
                let decoded = try JSONDecoder().decode(GeoNamesResponse.self, from: data)

                Task { @MainActor in
                    self.isLoading = false
                    self.places = Array(decoded.geonames.prefix(10))

                    if self.places.isEmpty {
                        self.errorMessage = "No nearby places found."
                    } else if let first = self.places.first {
                        self.region = MKCoordinateRegion(
                            center: first.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
                        )
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
}
