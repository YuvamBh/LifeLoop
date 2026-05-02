//
//  ProfileView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/26/26.
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
                        .foregroundStyle(.mint)

                    Text("Your Profile")
                        .font(.system(size: 32, weight: .bold, design: .rounded))

                    Text("Your self-growth summary")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                cardView {
                    Text("Progress Summary")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))

                    statRow(title: "Total Loops", value: "\(loops.count)")
                    statRow(title: "Completed Loops", value: "\(completedLoops)")
                    statRow(title: "Active Loops", value: "\(activeLoops)")
                    statRow(title: "Total Reflections", value: "\(reflections.count)")
                    statRow(title: "Saved Likes", value: "\(likedPosts.count)")
                    statRow(title: "Average Mood", value: reflections.isEmpty ? "N/A" : String(format: "%.1f / 10", averageMood))
                    statRow(title: "Completion Rate", value: String(format: "%.0f%%", completionRate))
                    statRow(title: "Progress Level", value: progressLevel)
                }

                cardView {
                    Text("Completion Progress")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))

                    ProgressView(value: completionRate, total: 100)
                        .tint(.mint)

                    Text(String(format: "%.0f%% of your loops are completed", completionRate))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                cardView {
                    Text("Latest Reflection")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))

                    if let latestReflection {
                        Text(latestReflection.loopTitle)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))

                        Text(latestReflection.reflectionText)
                            .font(.system(size: 15, weight: .regular, design: .rounded))

                        Text("Mood: \(latestReflection.mood)/10")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No reflections saved yet.")
                            .foregroundStyle(.secondary)
                    }
                }

                cardView {
                    Text("About LifeLoop")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))

                    Text("LifeLoop helps users create growth loops, track completion, save reflections, like community posts, and discover nearby places using map and web API data.")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .regular, design: .rounded))

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(.mint)
        }
    }

    private func cardView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
