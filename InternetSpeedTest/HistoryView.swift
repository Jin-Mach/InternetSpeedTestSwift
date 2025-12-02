//
//  HistoryView.swift
//  InternetSpeedTest
//
//  Created by Jindřich Machytka on 30.11.2025.
//

import SwiftUI

struct HistoryView: View {
    
    @Binding var isVisible: Bool
    
    @State private var data: [(String, Double)] = []
    @State private var deleteData: Bool = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("History")
                .font(.title)
            
            HStack {
                Text("Date")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Download speed")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 20)
            
            Divider()

            List(data.indices, id: \.self) { index in
                let item = data[index]
                HStack {
                    Text(item.0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    let formated = String(format: "%.2f", item.1)
                    Text("\(formated) MB/s")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
            Button("Delete data") {
                deleteData = true
                }
                .font(.system(size: 20, weight: .semibold, design: .default))
                .alert("Are you sure you want to clear history?", isPresented: $deleteData) {
                    Button("Yes", role: .destructive) {
                        clearData()
                        data = []
                    }
                    Button("No", role: .cancel) { }
            }
            .padding()
            
            Button("Close") {
                isVisible.toggle()
            }
            .font(.system(size: 20, weight: .semibold, design: .default))
            .padding()
        }
        .padding()
        .onAppear {
            let loaded = Array(loadData().reversed())
            data = loaded.compactMap { dict in
                if let date = dict["date"] as? String,
                   let speed = dict["result"] as? Double {
                    return (date, speed)
                }
                return nil
            }
        }
    }
    
}
