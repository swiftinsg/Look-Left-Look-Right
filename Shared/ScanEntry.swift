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
    
    var name: String
    
    var image: Data
    enum CodingKeys: String, CodingKey {
        case date = "d"
        case id = "i"
        case name = "n"
        case image = "im"
    }
    
    static let alumniId: String = "alumni"
    
    init(date: Date, id: String, name: String, image: Data) {
        self.date = date
        self.id = id
        self.name = name
        self.image = image
    }
    
    init(student: StudentExport) {
        self.date = Date.now
        self.id = student.uuid.uuidString
        self.name = student.name
        // empty image
        self.image = Data()
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.date.ISO8601Format(), forKey: .date)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.image, forKey: .image)
    }
}
