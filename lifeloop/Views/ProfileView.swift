//
//  ProfileView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/14/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var loops: [GrowthLoop]
    @Query private var reflections: [ReflectionEntry]

    var completedLoops: Int {
        loops.filter { $0.isCompleted }.count
    }

    var averageMood: Double {
        guard !reflections.isEmpty else { return 0.0 }
        let total = reflections.reduce(0) { $0 + $1.mood }
        return Double(total) / Double(reflections.count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)

                    Text("Your Profile")
                        .font(.largeTitle)
                        .bold()

                    Text("Track your loops and reflections")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Stats")
                        .font(.headline)

                    statRow(title: "Total Loops", value: "\(loops.count)")
                    statRow(title: "Completed Loops", value: "\(completedLoops)")
                    statRow(title: "Total Reflections", value: "\(reflections.count)")
                    statRow(title: "Average Mood", value: reflections.isEmpty ? "N/A" : String(format: "%.1f / 10", averageMood))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 12) {
                    Text("About This App")
                        .font(.headline)

                    Text("LifeLoop helps users create growth loops, track completion, save reflections, and discover nearby places using maps and web API data.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Spacer()
            }
            .padding()
        }
    }

    @ViewBuilder
    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .bold()
        }
    }
}
