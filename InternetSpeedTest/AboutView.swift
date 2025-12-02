//
//  AboutView.swift
//  InternetSpeedTest
//
//  Created by Jindřich Machytka on 30.11.2025.
//

import SwiftUI

struct AboutView: View {
    
    @Binding var isVisible: Bool
    
    var body: some View {
        
        VStack {
            Form {
                HStack { Text("App Name:"); Spacer(); Text("Internet Speed Test") }
                HStack { Text("Version:"); Spacer(); Text("1.0") }
                HStack { Text("Author:"); Spacer(); Text("Jin-Mach") }
                HStack { Text("About me:"); Spacer(); Link("GitHub", destination: URL(string: "https://github.com/Jin-Mach")!) }
            }
            .padding()

            Text("""
                Internet Speed Test lets you easily measure your internet connection speed.  
                The results are saved to history so you can track changes over time.  
                The app displays the current download speed in MB/s and the test duration, all clearly and quickly.
            """)
            .font(.system(size: 16, weight: .regular, design: .default))
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxHeight: .infinity, alignment: .center)

            Button("Close") {
                isVisible.toggle()
            }
            .font(.system(size: 20, weight: .semibold, design: .default))
            .padding()
        }
    }
}
