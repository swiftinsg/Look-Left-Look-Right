//
//  StudentExport.swift
//  Look Left Look Right
//
//  Created by Sean on 5/5/25.
//
import Foundation

// reduced version of student struct for exporting
struct StudentExport: Codable, Equatable {
    // used for convenience
    var uuid: UUID
    var indexNumber: String
    var name: String
    
    static var sampleData: [StudentExport] {
        let json = """
            [{"streak":0,"cardID":"","batch":2025,"name":"Sean","uuid":"81695FFC-A3AD-48BA-8441-FA7E27610B94","indexNumber":"AM01","session":"AM","studentType":"Student"}]
            """
        let decoder = JSONDecoder()
        do {
            let students: [StudentExport] = try decoder.decode([StudentExport].self, from: json.data(using: .utf8)!)
            return students
        } catch {
            print("Error parsing sample data: \(error)")
            return []
        }
    }
}
