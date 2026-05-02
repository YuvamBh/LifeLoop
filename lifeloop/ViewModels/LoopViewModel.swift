//
//  LoopViewModel.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/11/26.
//

import Foundation
import SwiftData
import Combine

final class LoopViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var category: String = "Wellness"
    @Published var goal: String = ""
    @Published var frequency: String = "Daily"
    @Published var selectedFilter: String = "All"

    let categories = ["Wellness", "Reading", "Study", "Exercise", "Mindfulness"]
    let frequencies = ["Daily", "Weekly"]
    let filterOptions = ["All", "Active", "Completed"]

    func clearForm() {
        title = ""
        category = "Wellness"
        goal = ""
        frequency = "Daily"
    }

    func isValidLoop() -> Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func filteredLoops(from loops: [GrowthLoop]) -> [GrowthLoop] {
        if selectedFilter == "Completed" {
            return loops.filter { $0.isCompleted }
        } else if selectedFilter == "Active" {
            return loops.filter { !$0.isCompleted }
        } else {
            return loops
        }
    }

    func addLoop(context: ModelContext) {
        guard isValidLoop() else { return }

        let newLoop = GrowthLoop(
            title: title,
            category: category,
            goal: goal,
            frequency: frequency
        )

        context.insert(newLoop)

        do {
            try context.save()
            clearForm()
        } catch {
            print("Error saving loop: \(error.localizedDescription)")
        }
    }

    func markLoopCompleted(loop: GrowthLoop, context: ModelContext) {
        loop.isCompleted = true

        do {
            try context.save()
        } catch {
            print("Error updating loop: \(error.localizedDescription)")
        }
    }

    func deleteLoop(at offsets: IndexSet, from loops: [GrowthLoop], context: ModelContext) {
        let filteredLoops = filteredLoops(from: loops)

        for index in offsets {
            context.delete(filteredLoops[index])
        }

        do {
            try context.save()
        } catch {
            print("Error deleting loop: \(error.localizedDescription)")
        }
    }
}
