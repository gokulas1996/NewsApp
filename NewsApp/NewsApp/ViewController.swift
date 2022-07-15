//
//  ViewController.swift
//  NewsApp
//
//  Created by Gokul A S on 15/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    var networkManagerObj = NetworkManager.networkManager
    var newsData: NewsData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkManagerObj.fetchData { data, status, error in
            if let data = data {
                self.newsData = data
            } else if let error = error {
                print(error)
            }
        }
    }
}

