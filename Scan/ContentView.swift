//
//  ContentView.swift
//  Scan
//
//  Created by Jia Chen Yee on 5/4/25.
//

import SwiftUI
struct ContentView: View {
    
    @State var ipAddress: String = ""
    @State var students: [StudentExport] = StudentExport.sampleData
    var body: some View {
        if ipAddress == "" {
            EnterIPView(ip: $ipAddress)
        } else {
            TabView {
                Tab {
                    ScanView(ipAddress: $ipAddress, students: students)
                } label: {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }
                Tab {
                    StudentsView(students: students)
                } label: {
                    Label("Students", systemImage: "person")
                }
                
            }
        }
        
    }
}

