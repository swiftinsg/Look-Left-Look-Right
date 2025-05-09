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
    var index: String
    var name: String
    var group: Group {
        // index number is in AM01 format - AM for session, 01 for number
        var group = Group(session: .afternoon, groupNumber: 1)
        let session = index[index.startIndex]
        if index.count != 4 {
            group.isAlumni = true
            group.session = .morning
            group.groupNumber = Int.max
            return group
        }
        if let number = Int(index[index.index(index.startIndex, offsetBy: 2)...index.endIndex]) {
            if session == "A" {
                group.session = .morning
            } else {
                group.session = .afternoon
            }
            group.groupNumber = (number % 8) + 1
        } else {
            group.isAlumni = true
            group.session = .morning
            group.groupNumber = Int.max
        }
        
        return group
    }
    var image: Data
    enum CodingKeys: String, CodingKey {
        case date = "d"
        case id = "i"
        case name = "n"
        case index = "idx"
        case image = "im"
    }
    
    static let alumniId: String = "alumni"
    
    init(date: Date, id: String, index: String, name: String, image: Data) {
        self.date = date
        self.id = id
        self.name = name
        self.image = image
        self.index = index
        
    }
    
    init(student: StudentExport) {
        self.date = Date.now
        self.id = student.uuid.uuidString
        self.index = student.indexNumber
        self.name = student.name
        // empty image
        self.image = Data()
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.date.ISO8601Format(), forKey: .date)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.index, forKey: .index)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.image, forKey: .image)
    }
}

#if os(macOS)
import AppKit

extension ScanEntry {
    func toImage() -> NSImage {
        NSImage(data: image)!
    }
}
#endif
