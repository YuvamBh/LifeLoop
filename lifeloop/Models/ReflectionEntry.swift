//
//  ReflectionEntry.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/29/26.
//

import Foundation
import SwiftData

@Model
final class ReflectionEntry {
    var id: UUID
    var loopTitle: String
    var reflectionText: String
    var mood: Int
    var imageData: Data?
    var createdAt: Date

    init(
        loopTitle: String,
        reflectionText: String,
        mood: Int,
        imageData: Data? = nil,
        createdAt: Date = Date()
    ) {
        self.id = UUID()
        self.loopTitle = loopTitle
        self.reflectionText = reflectionText
        self.mood = mood
        self.imageData = imageData
        self.createdAt = createdAt
    }
}
