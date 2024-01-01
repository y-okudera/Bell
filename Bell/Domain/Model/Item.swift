//
//  Item.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/01.
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
