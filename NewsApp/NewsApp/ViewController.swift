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
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        self.activityController(startRunning: true)
        self.fetchData {
            self.activityController(startRunning: false)
        }
    }
    
    
    func fetchData(completion: @escaping () -> ()) {
        self.networkManagerObj.fetchData { data, status, error in
            if let data = data {
                self.newsData = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    completion()
                }
                
            } else if let error = error {
                print(error)
                completion()
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.activityController(startRunning: true)
        self.fetchData {
            self.activityController(startRunning: false)
            self.refreshControl.endRefreshing()
        }
    }
    
    func activityController(startRunning: Bool) {
        self.activityIndicator.isHidden = startRunning == true ? false : true
        self.view.alpha = startRunning == true ? 0.5 : 1.0
        startRunning == true ? self.activityIndicator.startAnimating() :  self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = startRunning == true ? false : true
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
        if let imageURL = self.newsData?.articles?[indexPath.row].urlToImage {
            cell.newsImageView.imageFromServerURL(urlString: imageURL, PlaceHolderImage: UIImage(named: "PlaceholderImage")!)
        }
        
        return cell
    }
}

extension UIImageView {
    
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        if self.image == nil{
              self.image = PlaceHolderImage
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }}
