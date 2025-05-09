//
//  StudentsView.swift
//  Scan
//
//  Created by Sean on 5/5/25.
//

import SwiftUI

struct StudentsView: View {
    var students: [StudentExport]
    @Binding var selectedStudent: StudentExport?
    @Binding var appState: AppState
    var body: some View {
        NavigationStack {
            List(students, id: \.uuid) { student in
                
                Button {
                    selectedStudent = student
                    withAnimation {
                        
                        appState = .profileSetup
                    }
                    
                } label: {
                    VStack {
                        Text(student.name)
                    }
                }
            }
            .navigationTitle(Text("Students"))
        }
        
    }
}
