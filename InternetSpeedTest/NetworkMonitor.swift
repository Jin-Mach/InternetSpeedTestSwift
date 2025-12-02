//
//  NetworkMonitor.swift
//  InternetSpeedTest
//
//  Created by Jindřich Machytka on 30.11.2025.
//

import Network
import Combine
import SwiftUI

class NetworkMonitor: ObservableObject {
    
    @Published var isConnected: Bool = false
    
    public var connectionType: String = ""
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                if path.usesInterfaceType(NWInterface.InterfaceType.wifi) {
                    self.connectionType = "(Wi-Fi)"
                } else if path.usesInterfaceType(NWInterface.InterfaceType.cellular) {
                    self.connectionType = "(Mobile data)"
                } else {
                    self.connectionType = "Other connection"
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
