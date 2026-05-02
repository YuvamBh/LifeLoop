//
//  AddCommunityPostView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 5/1/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddCommunityPostView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = ReflectionViewModel()
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        Form {
            Section(header: Text("Post")) {
                TextField("What did you work on today?", text: $viewModel.reflectionText, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
            }

            Section(header: Text("Mood")) {
                VStack(alignment: .leading) {
                    Text("Mood (\(Int(viewModel.mood))/10)")
                    Slider(value: $viewModel.mood, in: 1...10, step: 1)
                        .tint(.mint)
                }
            }

            Section(header: Text("Picture")) {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Add Picture", systemImage: "photo")
                }

                if let imageData = viewModel.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            Section {
                Button("Post to Community") {
                    viewModel.saveReflection(
                        loopTitle: "Community Post",
                        context: modelContext
                    )
                    dismiss()
                }
                .disabled(!viewModel.isValidReflection())
            }
        }
        .navigationTitle("Add Post")
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.imageData = data
                }
            }
        }
    }
}
