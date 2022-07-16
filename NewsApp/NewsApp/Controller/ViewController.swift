//
//  ViewController.swift
//  NewsApp
//
//  Created by Gokul A S on 15/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    var networkManagerObj = NetworkManager.shared
    var newsData: NewsData?
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRefershControl()
        self.activityController(startRunning: true)
        self.fetchData {
            self.activityController(startRunning: false)
        }
    }
    
    // Function to add pull to refresh functionality
    func addRefershControl() {
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    
    //Function to call fetch data function from network manager class and handle the data
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
    
    // Funtion for pull to refresh
    @objc func refresh(_ sender: AnyObject) {
        self.fetchData {
            self.refreshControl.endRefreshing()
        }
    }
    
    // Funtion to control activity controller
    func activityController(startRunning: Bool) {
        self.activityIndicator.isHidden = startRunning == true ? false : true
        self.view.alpha = startRunning == true ? 0.5 : 1.0
        startRunning == true ? self.activityIndicator.startAnimating() :  self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = startRunning == true ? false : true
    }
}


// MARK: UITableView Functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData?.totalResults ?? 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId) as! NewsTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = self.newsData?.articles?[indexPath.row].title
        cell.descriptionLabel.text = self.newsData?.articles?[indexPath.row].description
        cell.authorLabel.text = self.newsData?.articles?[indexPath.row].author
        if let imageURL = self.newsData?.articles?[indexPath.row].urlToImage {
            // call function to fetch image from image url
            cell.newsImageView.imageFromServerURL(urlString: imageURL, PlaceHolderImage: UIImage(named: Constants.placeholderImage)!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = self.newsData?.articles?[indexPath.row].url, let url = URL(string: urlString) {
            // opens news url
            UIApplication.shared.open(url)
        }
    }
}

// MARK: UIIMageView Fetch function
extension UIImageView {
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        if self.image == nil{
              self.image = PlaceHolderImage
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}
