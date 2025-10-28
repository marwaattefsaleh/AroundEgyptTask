//
//  ReviewDTO.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

struct ReviewDTO: Codable, Identifiable {
    let id: String
    let experience: String?
    let name: String?
    let rating: Int?
    let comment: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, experience, name, rating, comment
        case createdAt = "created_at"
    }
}

