import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GrowthLoop.createdAt, order: .reverse) private var loops: [GrowthLoop]

    var body: some View {
        VStack {
            if loops.isEmpty {
                Spacer()
                Text("No growth loops yet")
                    .font(.headline)
                    .foregroundStyle(.gray)

                Text("Tap Add Loop to create your first loop.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    Section("My Loops") {
                        ForEach(loops) { loop in
                            NavigationLink(destination: LoopDetailView(loop: loop)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(loop.title)
                                            .font(.headline)

                                        Text(loop.category)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)

                                        Text(loop.frequency)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }

                                    Spacer()

                                    Image(systemName: loop.isCompleted ? "checkmark.square" : "square")
                                        .font(.title3)
                                        .foregroundStyle(loop.isCompleted ? .green : .gray)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteLoop)
                    }
                }
            }

            NavigationLink(destination: AddLoopView()) {
                Text("+ Add Loop")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
        .navigationTitle("LifeLoop")
    }

    private func deleteLoop(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(loops[index])
        }

        do {
            try modelContext.save()
        } catch {
            print("Error deleting loop: \(error.localizedDescription)")
        }
    }
}
