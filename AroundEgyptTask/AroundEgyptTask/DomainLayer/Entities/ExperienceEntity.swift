//
//  ExperienceEntity.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

struct ExperienceEntity: Identifiable {
    let id: String
    let title: String
    let desc: String?
    let coverPhoto: String?
    var likesNo: Int
    let viewsNo: Int
    let isRecommended: Bool
    let isRecent: Bool
    var isLiked: Bool
    let cityName: String?
    let order: Int

    mutating func updateLikes(from newValue: Int) {
           self.likesNo = newValue
       }
}
