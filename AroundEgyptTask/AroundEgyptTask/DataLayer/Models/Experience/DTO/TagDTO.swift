//
//  TagDTO.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

struct TagDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let disable: Bool?
    let topPick: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, disable
        case topPick = "top_pick"
    }
}

