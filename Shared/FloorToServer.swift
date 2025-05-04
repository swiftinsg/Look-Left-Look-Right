//
//  FloorToServer.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import Foundation

struct Floor: Codable, Identifiable, Sendable {
    var id: Int { index }
    
    var index: Int
    var gotHuman: Bool
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case index = "i"
        case gotHuman = "h"
        case date = "d"
    }
}
