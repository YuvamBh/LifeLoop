//
//  ReflectionListView.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 4/19/26.
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
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.reflectionText)
                            .font(.body)

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