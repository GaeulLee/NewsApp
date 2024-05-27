//
//  Articles.swift
//  NewsApp
//
//  Created by 이가을 on 5/27/24.
//

import Foundation

// MARK: - ArticleData
struct ArticleData: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
    
// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    //let publishedAt: Date
}

// MARK: - Source
struct Source: Codable {
    let name: String
}
