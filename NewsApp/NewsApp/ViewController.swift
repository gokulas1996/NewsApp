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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkManagerObj.fetchData { data, status, error in
            if let data = data {
                self.newsData = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if let error = error {
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData?.totalResults ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsTableViewCell
        cell.titleLabel.text = self.newsData?.articles?[indexPath.row].title
        cell.descriptionLabel.text = self.newsData?.articles?[indexPath.row].description
        cell.authorLabel.text = self.newsData?.articles?[indexPath.row].author
        return cell
    }
    
    
}
