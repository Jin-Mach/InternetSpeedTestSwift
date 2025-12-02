import SwiftUI

struct ContentView: View {
    
    @StateObject private var networkMonitor: NetworkMonitor = .init()
    
    private let networkLogic : NetworkLogic = NetworkLogic()
    @State private var dateNow: String = ""
    @State private var timeNow: String = ""
    @State private var downloadTime: Double = 0
    @State private var downloadSpeed: Double = 0
    
    @State private var started: Bool = true
    @State private var showProgressbar: Bool = false
    @State private var showResults: Bool = false
    @State private var showHistory: Bool = false
    @State private var showAbout: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Internet Speed Test")
                    .font(.title)
                    .padding()
                
                Text(networkMonitor.isConnected ? "Connected \(networkMonitor.connectionType)" : "No internet connection")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                    .frame(height: 150)
                
                if started {
                    Image(systemName: "wifi")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(networkMonitor.isConnected ? .green : .red)
                        .opacity(0.5)
                        .padding()
                } else {
                    if showProgressbar {
                        VStack(spacing: 50) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(5.0)
                                .tint(.red)
                                .padding()
                            Text("Downloading...")
                                .padding()
                        }
                    } else if showResults {
                        VStack(spacing: 5) {
                            Text("Date: \(dateNow)")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                            Text("Time: \(timeNow)")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                            Spacer()
                                .frame(height: 20)
                            Text("Download speed: \(downloadSpeed, specifier: "%.2f") MB/s")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                            Text("Download time: \(downloadTime, specifier: "%.2f") s")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                Button("Start Test") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        started = false
                        showProgressbar = true
                        showResults = false
                    }

                    networkLogic.startDownload { result in
                        DispatchQueue.main.async {
                            switch result {

                            case .success(let (time, speed)):
                                let (currentDate, currentTime) = getCurrentTime()
                                dateNow = currentDate
                                timeNow = currentTime
                                downloadTime = time
                                downloadSpeed = speed
                                showProgressbar = false
                                showResults = true
                                saveData(date: dateNow, result: Double(downloadSpeed))

                            case .failure(let error):
                                errorMessage = error.localizedDescription
                                showErrorAlert = true
                                showProgressbar = false
                                showResults = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        started = true
                                    }
                                }
                            }
                        }
                    }
                }
                .font(.system(size: 20, weight: .semibold, design: .default))
                .disabled(!networkMonitor.isConnected || showProgressbar)
                .padding()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showHistory.toggle()
                    }) {
                        Image(systemName: "square.stack.3d.down.right")
                            .font(.title2)
                    }
                    .sheet(isPresented: $showHistory) {
                        HistoryView(isVisible: $showHistory)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAbout.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title2)
                    }
                    .sheet(isPresented: $showAbout) {
                        AboutView(isVisible: $showAbout)
                    }
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Download Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


#Preview {
    ContentView()
}
