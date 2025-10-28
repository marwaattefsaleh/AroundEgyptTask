//
//  TranslatedOpeningHoursDTO.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

struct TranslatedOpeningHoursDTO: Codable {
    let days: [String: TranslatedDayDTO]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.days = try container.decode([String: TranslatedDayDTO].self)
    }
}

struct TranslatedDayDTO: Codable {
    let day: String
    let time: String
}
