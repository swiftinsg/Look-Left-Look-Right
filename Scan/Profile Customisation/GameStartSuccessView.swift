//
//  GameStartSuccessView.swift
//  Scan
//
//  Created by Sean on 6/5/25.
//

import SwiftUI

struct GameStartSuccessView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var student: StudentExport?
    var body: some View {
        if let student {
            
            VStack {
                Text("Please head in, **\(student.name)**.")
                    .font(.headline)
                    .padding()
                    .task {
                        try! await Task.sleep(for: .seconds(5))
                        dismiss()
                    }
                
                Text("Good luck! Don't get run over.")
                
            }
        }
    }
}

