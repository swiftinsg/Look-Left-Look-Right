//
//  ScanEntry.swift
//  Look Left Look Right
//
//  Created by Jia Chen Yee on 5/4/25.
//

import Foundation

struct ScanEntry: Codable {
    var date: Date
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case date = "d"
        case id = "i"
    }
    
    static let alumniId: String = "alumni"
}
