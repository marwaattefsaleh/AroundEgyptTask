//
//  Item.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
