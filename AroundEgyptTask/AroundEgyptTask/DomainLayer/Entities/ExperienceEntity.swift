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
    let likesNo: Int
    let viewsNo: Int
    let isRecommended: Bool
    let isRecent: Bool
    var isLiked: Bool
    let cityName: String?
}
