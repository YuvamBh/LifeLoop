//
//  GeoNamesResponse.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//

import Foundation

struct GeoNamesResponse: Codable {
    let geonames: [Place]
}

struct Place: Codable, Identifiable {
    let geonameId: Int?
    let name: String
    let countryName: String?
    let lat: Double
    let lng: Double
    let population: Int?

    var id: Int {
        geonameId ?? Int.random(in: 1...999999)
    }

    var latitude: Double {
        lat
    }

    var longitude: Double {
        lng
    }
}
