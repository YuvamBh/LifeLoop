//
//  GeoNamesResponse.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//


import Foundation
import MapKit

struct GeoNamesResponse: Codable {
    let geonames: [Place]
}

struct Place: Codable, Identifiable {
    let geonameId: Int?
    let name: String
    let countryName: String?
    let lat: String
    let lng: String
    let population: Int?

    var id: Int {
        geonameId ?? UUID().hashValue
    }

    var latitude: Double {
        Double(lat) ?? 0.0
    }

    var longitude: Double {
        Double(lng) ?? 0.0
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}