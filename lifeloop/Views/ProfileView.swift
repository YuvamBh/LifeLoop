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
    @Query(sort: \ReflectionEntry.createdAt, order: .reverse) private var reflections: [ReflectionEntry]
    @Query private var likedPosts: [LikedPost]

    var completedLoops: Int {
        loops.filter { $0.isCompleted }.count
    }

    var activeLoops: Int {
        loops.filter { !$0.isCompleted }.count
    }

    var completionRate: Double {
        if loops.isEmpty {
            return 0.0
        }

        return (Double(completedLoops) / Double(loops.count)) * 100
    }

    var averageMood: Double {
        if reflections.isEmpty {
            return 0.0
        }

        let totalMood = reflections.reduce(0) { total, entry in
            total + entry.mood
        }

        return Double(totalMood) / Double(reflections.count)
    }

    var progressLevel: String {
        if completedLoops == 0 {
            return "Beginner"
        } else if completedLoops < 3 {
            return "Building Momentum"
        } else {
            return "Consistent"
        }
    }

    var latestReflection: ReflectionEntry? {
        reflections.first
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)

                    Text("Your Profile")
                        .font(.largeTitle)
                        .bold()

                    Text("Your self-growth summary")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Progress Summary")
                        .font(.headline)

                    statRow(title: "Total Loops", value: "\(loops.count)")
                    statRow(title: "Completed Loops", value: "\(completedLoops)")
                    statRow(title: "Active Loops", value: "\(activeLoops)")
                    statRow(title: "Total Reflections", value: "\(reflections.count)")
                    statRow(title: "Saved Likes", value: "\(likedPosts.count)")
                    statRow(title: "Average Mood", value: reflections.isEmpty ? "N/A" : String(format: "%.1f / 10", averageMood))
                    statRow(title: "Completion Rate", value: String(format: "%.0f%%", completionRate))
                    statRow(title: "Progress Level", value: progressLevel)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Completion Progress")
                        .font(.headline)

                    ProgressView(value: completionRate, total: 100)
                        .progressViewStyle(.linear)

                    Text(String(format: "%.0f%% of your loops are completed", completionRate))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Latest Reflection")
                        .font(.headline)

                    if let latestReflection {
                        Text(latestReflection.loopTitle)
                            .font(.subheadline)
                            .bold()

                        Text(latestReflection.reflectionText)
                            .font(.body)

                        Text("Mood: \(latestReflection.mood)/10")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No reflections saved yet.")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 10) {
                    Text("About LifeLoop")
                        .font(.headline)

                    Text("LifeLoop helps users create growth loops, track completion, save reflections, like community posts, and discover nearby places using map and web API data.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding()
        }
        .navigationTitle("Profile")
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .bold()
        }
    }
}
