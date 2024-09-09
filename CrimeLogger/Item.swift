//
//  Item.swift
//  CrimeLogger
//
//  Created by polina on 09.09.2024.
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
