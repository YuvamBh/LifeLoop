//
//  HomeView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/15/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GrowthLoop.createdAt, order: .reverse) private var loops: [GrowthLoop]
    @StateObject private var viewModel = LoopViewModel()

    var filteredLoops: [GrowthLoop] {
        viewModel.filteredLoops(from: loops)
    }

    var body: some View {
        VStack {
            if loops.isEmpty {
                Spacer()

                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.mint)

                Text("No growth loops yet")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("Tap Add Loop to create your first loop.")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)

                Spacer()
            } else {
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(viewModel.filterOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)

                List {
                    Section("My Loops") {
                        if filteredLoops.isEmpty {
                            Text("No loops for this filter.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(filteredLoops) { loop in
                                NavigationLink(destination: LoopDetailView(loop: loop)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(loop.title)
                                                .font(.system(size: 18, weight: .semibold, design: .rounded))

                                            Text(loop.category)
                                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                                .foregroundStyle(.secondary)

                                            Text(loop.frequency)
                                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                                .foregroundStyle(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: loop.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.title3)
                                            .foregroundStyle(loop.isCompleted ? .mint : .gray)
                                    }
                                    .padding(.vertical, 6)
                                }
                            }
                            .onDelete { offsets in
                                viewModel.deleteLoop(at: offsets, from: loops, context: modelContext)
                            }
                        }
                    }
                }
            }

            NavigationLink(destination: AddLoopView()) {
                Text("+ Add Loop")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.mint)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
        .navigationTitle("LifeLoop")
    }
}
