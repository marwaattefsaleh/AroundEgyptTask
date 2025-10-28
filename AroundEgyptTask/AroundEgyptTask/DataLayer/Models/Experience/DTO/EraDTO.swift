//
//  EraDTO.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

struct EraDTO: Codable, Identifiable {
    let id: String
    let value: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

