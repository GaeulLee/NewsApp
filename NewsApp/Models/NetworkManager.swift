//
//  ArticleManager.swift
//  NewsApp
//
//  Created by 이가을 on 5/27/24.
//

import Foundation

protocol NetworkManagerDelegate {
    func didUpdateArticles(_ articleManager: NetworkManager, _ articles: ArticleData)
    func didFailWithError(error: Error)
}

final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}
    
    var delegate: NetworkManagerDelegate?
    
    
    
    func fetchArticles() {
        let url = "https://newsapi.org/v2/top-headlines?apiKey=\(K.apiKey)&country=kr"
        print(url)
        performRequest(with: url)
    }
    
    func fetchArticles(searchFor: String) {
        let url = "https://newsapi.org/v2/everything?apiKey=\(K.apiKey)&q=\(searchFor)"
        performRequest(with: url)
    }
    
    
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) { // 1. create a URL
            let session = URLSession(configuration: .default) // 2. create a URLSession
            let task = session.dataTask(with: url) { data, response, error in // 3. give the session a task
                if error != nil {
                    print(#function)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let articles = self.parseJSON(safeData) {
                        print(articles.articles.count)
                        self.delegate?.didUpdateArticles(self, articles)
                    }
                }
            }
            task.resume() // 4. start the task
        }
    }
    
    private func parseJSON(_ articleData: Data) -> ArticleData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ArticleData.self, from: articleData)
            
            let status = decodedData.status
            let totalResults = decodedData.totalResults
            let articles = decodedData.articles
            let results = ArticleData(status: status, totalResults: totalResults, articles: articles)
            
            return results
        } catch {
            print(#function)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
