//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Gokul A S on 15/07/22.
//

import Foundation

enum Status {
    case success
    case error
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    private override init() {}
    
    // Network manager function to fetch data from url
    func fetchData(completionHandler : @escaping (_ data: NewsData?, _ status: Status?, _ error: Error?) -> Void) {
        guard let url = URL(string:"\(Constants.url)\(Constants.apiKey)") else{ return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let tasks = try JSONDecoder().decode(NewsData.self, from: data)
                    completionHandler(tasks, .success, nil)
                }
                catch {
                    print(error)
                    completionHandler(nil, .error, error)
                }
            }
        }
        task.resume()
    }
}
