//
//  NewsData.swift
//  NewsApp
//
//  Created by Gokul A S on 15/07/22.
//

import Foundation

struct NewsData: Codable {
    var totalResults: Int?
    var articles: [Articles]?
}

struct Articles: Codable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

