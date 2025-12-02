//
//  Helpers.swift
//  InternetSpeedTest
//
//  Created by Jindřich Machytka on 30.11.2025.
//

import SwiftUI

func getCurrentTime() -> (String, String) {
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let dateString = formatter.string(from: currentDateTime)
    formatter.dateFormat = "HH:mm:ss"
    let timeString = formatter.string(from: currentDateTime)
    return (date: dateString, time: timeString)
}
