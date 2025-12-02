//
//  HistoryLogic.swift
//  InternetSpeedTest
//
//  Created by Jindřich Machytka on 30.11.2025.
//

import Foundation

let userDefaults = UserDefaults.standard

func saveData(date: String, result: Double) {
    let newRecord: [String: Any] = ["date": date, "result": result]
    var records: [[String: Any]] = []
    if let existingRecords = userDefaults.array(forKey: "history") as? [[String: Any]] {
        records = existingRecords
    }
    records.append(newRecord)
    userDefaults.set(records, forKey: "history")
}

func loadData() -> [[String: Any]] {
    return userDefaults.array(forKey: "history") as? [[String: Any]] ?? []
}

func clearData() {
    userDefaults.removeObject(forKey: "history")
}
