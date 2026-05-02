//
//  LoopDetailView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/29/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct LoopDetailView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var loop: GrowthLoop
    @StateObject private var loopViewModel = LoopViewModel()
    @StateObject private var reflectionViewModel = ReflectionViewModel()

    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(loop.title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))

                    Text("Category: \(loop.category)")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))

                    Text("Goal: \(loop.goal)")
                        .font(.system(size: 15, weight: .regular, design: .rounded))

                    Text("Frequency: \(loop.frequency)")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)

                    Text("Status: \(loop.isCompleted ? "Completed" : "Not Completed")")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(loop.isCompleted ? .mint : .red)
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
                        .font(.system(size: 15, weight: .regular, design: .rounded))

                    Slider(value: $reflectionViewModel.mood, in: 1...10, step: 1)
                        .tint(.mint)
                }

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Add Picture", systemImage: "photo")
                }

                if let imageData = reflectionViewModel.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button("Save Entry") {
                    reflectionViewModel.saveReflection(for: loop, context: modelContext)
                    selectedPhoto = nil
                }
                .disabled(!reflectionViewModel.isValidReflection())
            }

            ReflectionListView(loopTitle: loop.title)
        }
        .navigationTitle("Loop Detail")
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    reflectionViewModel.imageData = data
                }
            }
        }
    }
}
