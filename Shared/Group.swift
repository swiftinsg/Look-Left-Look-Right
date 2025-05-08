//
//  Group.swift
//  Look Left Look Right
//
//  Created by Sean on 9/5/25.
//


struct Group: Codable {
    enum Session: String, Codable {
        case morning = "AM"
        case afternoon = "PM"
    }
    var session: Session
    var groupNumber: Int
    var isAlumni = false
    
    var stringRepresentation: String {
        if isAlumni {
            return "Alumni"
        } else {
            return "\(groupNumber)\(session.rawValue)"
        }
    }
}
