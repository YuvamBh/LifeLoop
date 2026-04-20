import SwiftUI
import SwiftData

@main
struct LifeLoopApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [GrowthLoop.self, ReflectionEntry.self])
    }
}
