import Foundation
import SwiftData

@Model
final class GrowthLoop {
    var id: UUID
    var title: String
    var category: String
    var goal: String
    var frequency: String
    var isCompleted: Bool
    var createdAt: Date

    init(
        title: String,
        category: String,
        goal: String,
        frequency: String,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.goal = goal
        self.frequency = frequency
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
