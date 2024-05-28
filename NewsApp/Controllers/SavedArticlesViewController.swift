//
//  SavedArticlesViewController.swift
//  NewsApp
//
//  Created by 이가을 on 5/23/24.
//

import UIKit

class SavedArticlesViewController: UIViewController {

    @IBOutlet weak var savedTableView: UITableView!
    
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTableView.dataSource = self

        setupUI()
    }
    
    func setupUI(){
        savedTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //networkManager.fetchArticles(searchFor: "apple")
    }

}


// MARK: - UITableViewDataSource
extension SavedArticlesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        print("count: \(articles.count)")
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        
        cell.titleLabel.text = articles[indexPath.row].title
        cell.descLabel.text = articles[indexPath.row].description
        cell.nameLabel.text = articles[indexPath.row].source.name
        cell.dateLabel.text = articles[indexPath.row].date
        cell.imageUrl = articles[indexPath.row].urlToImage
        
        return cell
    }
    
}
