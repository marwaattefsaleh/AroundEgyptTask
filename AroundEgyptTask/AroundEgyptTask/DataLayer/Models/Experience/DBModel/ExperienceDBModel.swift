//
//  ExperienceDBModel.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftData
import Foundation

@Model
final class ExperienceDBModel {
    @Attribute(.unique) var id: String
    var title: String
    var desc: String?
    var coverPhoto: String?
    var likesNo: Int
    var viewsNo: Int
    var isRecommended: Bool
    var isRecent: Bool
    var isLiked: Bool
    var cityName: String?
    var order: Int = 0  // to preserve the list order

    init(id: String, title: String, desc: String, coverPhoto: String?, likesNo: Int, viewsNo: Int, isRecommended: Bool, isRecent: Bool, isLiked: Bool, cityName: String?, order: Int = 0) {
        self.id = id
        self.title = title
        self.desc = desc
        self.coverPhoto = coverPhoto
        self.likesNo = likesNo
        self.viewsNo = viewsNo
        self.isRecommended = isRecommended
        self.isRecent = isRecent
        self.isLiked = isLiked
        self.cityName = cityName
        self.order = order
    }
}

extension ExperienceDBModel {
    func toEntity() -> ExperienceEntity {
        return ExperienceEntity(id: id, title: title, desc: desc, coverPhoto: coverPhoto, likesNo: likesNo, viewsNo: viewsNo, isRecommended: isRecommended, isRecent: isRecent, isLiked: isLiked, cityName: cityName, order: order)
    }
}
