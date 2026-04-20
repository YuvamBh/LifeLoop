//
//  ReflectionEntry.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//


import Foundation
import SwiftData

@Model
final class ReflectionEntry {
    var id: UUID
    var loopTitle: String
    var reflectionText: String
    var mood: Int
    var createdAt: Date

    init(
        loopTitle: String,
        reflectionText: String,
        mood: Int,
        createdAt: Date = Date()
    ) {
        self.id = UUID()
        self.loopTitle = loopTitle
        self.reflectionText = reflectionText
        self.mood = mood
        self.createdAt = createdAt
    }
}
