//
//  Articles.swift
//  NewsApp
//
//  Created by 이가을 on 5/27/24.
//

import Foundation

// MARK: - ArticleData
struct ArticleData: Codable {
    let articles: [Article]
}
    
// MARK: - Article
struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    private let publishedAt: String
    
    var date: String {
        guard let isoDate = ISO8601DateFormatter().date(from: publishedAt ) else { return "" }
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = myFormatter.string(from: isoDate)

        return dateString
    }
}

// MARK: - Source
struct Source: Codable {
    let name: String
}
