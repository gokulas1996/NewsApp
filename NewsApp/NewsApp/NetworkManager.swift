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
    
    static let networkManager = NetworkManager()
    
    private override init() {}
    
    func fetchData(completionHandler : @escaping (_ data: NewsData?, _ status: Status?, _ error: Error?) -> Void) {
        guard let url = URL(string:"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=5c282f975e454fc799a32d94782da93e") else{ return }
        
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
