//
//  ReflectionViewModel.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/29/26.
//

import Foundation
import SwiftData
import Combine

final class ReflectionViewModel: ObservableObject {
    @Published var reflectionText: String = ""
    @Published var mood: Double = 5.0
    @Published var imageData: Data?

    func clearForm() {
        reflectionText = ""
        mood = 5.0
        imageData = nil
    }

    func isValidReflection() -> Bool {
        !reflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func saveReflection(for loop: GrowthLoop, context: ModelContext) {
        saveReflection(
            loopTitle: loop.title,
            context: context
        )
    }

    func saveReflection(loopTitle: String, context: ModelContext) {
        guard isValidReflection() else { return }

        let newReflection = ReflectionEntry(
            loopTitle: loopTitle,
            reflectionText: reflectionText,
            mood: Int(mood),
            imageData: imageData
        )

        context.insert(newReflection)

        do {
            try context.save()
            clearForm()
        } catch {
            print("Error saving reflection: \(error.localizedDescription)")
        }
    }
}
