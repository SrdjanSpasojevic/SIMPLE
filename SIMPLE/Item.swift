//
//  Item.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 10. 3. 2026..
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
