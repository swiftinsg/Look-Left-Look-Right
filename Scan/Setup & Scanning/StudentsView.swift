//
//  StudentsView.swift
//  Scan
//
//  Created by Sean on 5/5/25.
//

import SwiftUI

struct StudentsView: View {
    var students: [StudentExport]
    var body: some View {
        NavigationStack {
            List(students, id: \.uuid) { student in
                VStack {
                    Text(student.name)
                }
            }
            
        }
        .navigationTitle(Text("Students"))
    }
}
