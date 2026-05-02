//
//  ReflectionListView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/29/26.
//

import SwiftUI
import SwiftData

struct ReflectionListView: View {
    let loopTitle: String

    @Query(sort: \ReflectionEntry.createdAt, order: .reverse) private var allReflections: [ReflectionEntry]

    var filteredReflections: [ReflectionEntry] {
        allReflections.filter { $0.loopTitle == loopTitle }
    }

    var body: some View {
        Section(header: Text("Past Reflections")) {
            if filteredReflections.isEmpty {
                Text("No reflections yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(filteredReflections) { entry in
                    VStack(alignment: .leading, spacing: 8) {
                        if let imageData = entry.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Text(entry.reflectionText)
                            .font(.system(size: 15, weight: .regular, design: .rounded))

                        Text("Mood: \(entry.mood)/10")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}
