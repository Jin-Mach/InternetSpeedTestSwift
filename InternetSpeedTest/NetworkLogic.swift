//
//  NetworkLogic.swift
//  InternetSpeedTest
//
//  Created by Jindřich Machytka on 30.11.2025.
//

import Foundation

struct NetworkLogic {
    
    private let urlFile = URL(string: "https://download.thinkbroadband.com/5MB.zip")!

    func startDownload(completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        
        let startTime = Date()
        
        URLSession.shared.downloadTask(with: urlFile) { tempURL, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL,
                  let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode)
            else {
                completion(.failure(NSError(domain: "DownloadError",
                                            code: 1,
                                            userInfo: [NSLocalizedDescriptionKey: "Neplatná odpověď serveru"])))
                return
            }
            let elapsed = Date().timeIntervalSince(startTime)
            let attributes = try? FileManager.default.attributesOfItem(atPath: tempURL.path)
            let fileSize = (attributes?[.size] as? NSNumber)?.doubleValue ?? 0
            let speed = (fileSize / elapsed) / 1_000_000

            completion(.success((elapsed, speed)))
        }.resume()
    }
}
