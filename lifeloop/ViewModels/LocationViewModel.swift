//
//  LocationViewModel.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//


import Foundation
import MapKit
import CoreLocation

final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var places: [Place] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
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
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let coordinate = location.coordinate
        userCoordinate = coordinate

        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )

        fetchNearbyPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    func fetchNearbyPlaces(latitude: Double, longitude: Double) {
        let north = latitude + 0.1
        let south = latitude - 0.1
        let east = longitude + 0.1
        let west = longitude - 0.1

        let urlString = "https://api.geonames.org/citiesJSON?north=\(north)&south=\(south)&east=\(east)&west=\(west)&lang=en&username=YOUR_USERNAME"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(GeoNamesResponse.self, from: data)

                DispatchQueue.main.async {
                    self.places = Array(decoded.geonames.prefix(10))

                    if let first = self.places.first {
                        self.region = MKCoordinateRegion(
                            center: first.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
                        )
                    }
                }
            } catch {
                print("JSON decode error: \(error.localizedDescription)")
            }
        }.resume()
    }
}