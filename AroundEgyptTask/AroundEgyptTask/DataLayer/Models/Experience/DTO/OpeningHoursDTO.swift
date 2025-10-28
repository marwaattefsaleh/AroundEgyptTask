//
//  OpeningHoursDTO.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

struct OpeningHoursDTO: Codable {
    let hours: [String: [String]]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // Try to decode as dictionary first
        if let dict = try? container.decode([String: [String]].self) {
            self.hours = dict
        }
        // If it's an empty array or wrong type, fall back to empty dictionary
        else if let _ = try? container.decode([String].self) {
            self.hours = [:]
        }
        // Otherwise, fallback for any unexpected structure
        else {
            self.hours = [:]
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hours)
    }
}

