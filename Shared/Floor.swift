//
//  Floor.swift
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

    init(index: Int, gotHuman: Bool, date: Date) {
        self.index = index
        self.gotHuman = gotHuman
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        index = try container.decode(Int.self, forKey: .index)
        gotHuman = try container.decode(Bool.self, forKey: .gotHuman)

        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = ISO8601DateFormatter()
        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container,
                                                   debugDescription: "Date string does not match format expected by ISO8601DateFormatter.")
        }
        date = parsedDate
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(index, forKey: .index)
        try container.encode(gotHuman, forKey: .gotHuman)

        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)
        try container.encode(dateString, forKey: .date)
    }
}

