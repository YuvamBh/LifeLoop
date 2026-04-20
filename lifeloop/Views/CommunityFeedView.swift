//
//  CommunityFeedView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/17/26.
//

import SwiftUI
import SwiftData

struct CommunityFeedView: View {
    @Query(sort: \ReflectionEntry.createdAt, order: .reverse)
    private var reflections: [ReflectionEntry]

    @State private var likedPosts: Set<UUID> = []

    var body: some View {
        List {
            if reflections.isEmpty {
                Text("No posts yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(reflections) { entry in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.loopTitle)
                            .font(.headline)

                        Text(entry.reflectionText)
                            .font(.body)

                        HStack {
                            Text("Mood: \(entry.mood)/10")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Spacer()

                            Button {
                                toggleLike(entry.id)
                            } label: {
                                Image(systemName: likedPosts.contains(entry.id) ? "heart.fill" : "heart")
                                    .foregroundStyle(.red)
                            }
                        }

                        Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Community Feed")
    }

    private func toggleLike(_ id: UUID) {
        if likedPosts.contains(id) {
            likedPosts.remove(id)
        } else {
            likedPosts.insert(id)
        }
    }
}
