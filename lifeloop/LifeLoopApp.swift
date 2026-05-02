//
//  LifeLoopApp.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//


import SwiftUI
import SwiftData

@main
struct LifeLoopApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [GrowthLoop.self, ReflectionEntry.self, LikedPost.self])
    }
}

