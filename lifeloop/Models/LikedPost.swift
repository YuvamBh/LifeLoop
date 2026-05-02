//
//  LikedPost.swift
//  lifeloop
//
//  Created by Yuvam Bhargav on 5/1/26.
//

import Foundation
import SwiftData

@Model
final class LikedPost {
    var id: UUID
    var reflectionID: UUID

    init(reflectionID: UUID) {
        self.id = UUID()
        self.reflectionID = reflectionID
    }
}
