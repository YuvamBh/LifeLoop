//
//  LoopDetailView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//


import SwiftUI
import SwiftData

struct LoopDetailView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var loop: GrowthLoop
    @StateObject private var loopViewModel = LoopViewModel()
    @StateObject private var reflectionViewModel = ReflectionViewModel()

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(loop.title)
                        .font(.largeTitle)
                        .bold()

                    Text("Category: \(loop.category)")
                        .font(.headline)

                    Text("Goal: \(loop.goal)")
                        .font(.subheadline)

                    Text("Frequency: \(loop.frequency)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text("Status: \(loop.isCompleted ? "Completed" : "Not Completed")")
                        .font(.subheadline)
                        .foregroundStyle(loop.isCompleted ? .green : .red)
                }
                .padding(.vertical, 4)
            }

            Section {
                Button(loop.isCompleted ? "Already Completed" : "Mark as Completed") {
                    loopViewModel.markLoopCompleted(loop: loop, context: modelContext)
                }
                .disabled(loop.isCompleted)
            }

            Section(header: Text("Today's Entry")) {
                TextField("Write reflection...", text: $reflectionViewModel.reflectionText, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)

                VStack(alignment: .leading) {
                    Text("Mood (\(Int(reflectionViewModel.mood))/10)")
                    Slider(value: $reflectionViewModel.mood, in: 1...10, step: 1)
                }

                Button("Save Entry") {
                    reflectionViewModel.saveReflection(for: loop, context: modelContext)
                }
                .disabled(!reflectionViewModel.isValidReflection())
            }

            ReflectionListView(loopTitle: loop.title)
        }
        .navigationTitle("Loop Detail")
    }
}