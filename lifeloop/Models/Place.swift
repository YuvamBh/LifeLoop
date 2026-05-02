//
//  GeoNamesResponse.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//

import Foundation

struct OverpassResponse: Codable {
    let elements: [OverpassElement]
}

struct OverpassElement: Codable {
    let type: String
    let id: Int
    let lat: Double?
    let lon: Double?
    let center: OverpassCenter?
    let tags: OverpassTags?
}

struct OverpassCenter: Codable {
    let lat: Double
    let lon: Double
}

struct OverpassTags: Codable {
    let name: String?
    let amenity: String?
    let leisure: String?
}

struct Place: Identifiable {
    let id: Int
    let name: String
    let category: String
    let latitude: Double
    let longitude: Double

    var displayCategory: String {
        if category == "park" {
            return "Park"
        } else if category == "library" {
            return "Library"
        } else if category == "fitness" {
            return "Fitness Center"
        } else {
            return "Place"
        }
    }
}
