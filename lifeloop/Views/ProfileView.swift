import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var loops: [GrowthLoop]
    @Query private var reflections: [ReflectionEntry]

    var body: some View {
        VStack(spacing: 16) {
            Text("LifeLoop Profile")
                .font(.largeTitle)
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                Text("Total Loops: \(loops.count)")
                Text("Completed Loops: \(loops.filter { $0.isCompleted }.count)")
                Text("Total Reflections: \(reflections.count)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .padding()
    }
}