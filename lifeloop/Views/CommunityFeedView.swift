//
//  CommunityFeedView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/29/26.
//

import SwiftUI
import SwiftData

struct CommunityFeedView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ReflectionEntry.createdAt, order: .reverse)
    private var reflections: [ReflectionEntry]

    @Query
    private var likedPosts: [LikedPost]

    var body: some View {
        List {
            if reflections.isEmpty {
                Text("No posts yet")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(reflections) { entry in
                    VStack(alignment: .leading, spacing: 8) {
                        if let imageData = entry.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Text(entry.loopTitle)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))

                        Text(entry.reflectionText)
                            .font(.system(size: 15, weight: .regular, design: .rounded))

                        HStack {
                            Text("Mood: \(entry.mood)/10")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Spacer()

                            Button {
                                toggleLike(entry.id)
                            } label: {
                                Image(systemName: isLiked(entry.id) ? "heart.fill" : "heart")
                                    .foregroundStyle(.red)
                            }
                        }

                        Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Community Feed")
        .toolbar {
            NavigationLink(destination: AddCommunityPostView()) {
                Image(systemName: "plus")
            }
        }
    }

    private func isLiked(_ reflectionID: UUID) -> Bool {
        likedPosts.contains { likedPost in
            likedPost.reflectionID == reflectionID
        }
    }

    private func toggleLike(_ reflectionID: UUID) {
        if let existingLike = likedPosts.first(where: { $0.reflectionID == reflectionID }) {
            modelContext.delete(existingLike)
        } else {
            let newLike = LikedPost(reflectionID: reflectionID)
            modelContext.insert(newLike)
        }

        do {
            try modelContext.save()
        } catch {
            print("Error saving like: \(error.localizedDescription)")
        }
    }
}
