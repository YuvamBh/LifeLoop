//
//  ReflectionViewModel.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/11/26.
//

import Foundation
import SwiftData
import Combine

final class ReflectionViewModel: ObservableObject {
    @Published var reflectionText: String = ""
    @Published var mood: Double = 5.0

    func clearForm() {
        reflectionText = ""
        mood = 5.0
    }

    func isValidReflection() -> Bool {
        !reflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func saveReflection(for loop: GrowthLoop, context: ModelContext) {
        guard isValidReflection() else { return }

        let newReflection = ReflectionEntry(
            loopTitle: loop.title,
            reflectionText: reflectionText,
            mood: Int(mood)
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
