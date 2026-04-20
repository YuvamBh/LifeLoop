//
//  AddLoopView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
//


import SwiftUI
import SwiftData

struct AddLoopView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = LoopViewModel()

    var body: some View {
        Form {
            Section(header: Text("Loop Title")) {
                TextField("Enter Loop Title", text: $viewModel.title)
            }

            Section(header: Text("Category")) {
                Picker("Select Category", selection: $viewModel.category) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(.menu)
            }

            Section(header: Text("Goal")) {
                TextField("Specify your goal here...", text: $viewModel.goal, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }

            Section(header: Text("Frequency")) {
                Picker("Frequency", selection: $viewModel.frequency) {
                    ForEach(viewModel.frequencies, id: \.self) { item in
                        Text(item)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                Button("Save Loop") {
                    viewModel.addLoop(context: modelContext)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .disabled(!viewModel.isValidLoop())
            }
        }
        .navigationTitle("Add New Loop")
    }
}
