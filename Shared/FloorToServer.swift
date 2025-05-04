//
//  FloorToServer.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import Foundation

struct FloorToServer: Codable, Identifiable {
    var id: Int { index }
    
    var index: Int
    var gotHuman: Bool
    
    enum CodingKeys: String, CodingKey {
        case index = "i"
        case gotHuman = "h"
    }
}
