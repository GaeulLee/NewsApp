//
//  HomeViewController.swift
//  NewsApp
//
//  Created by 이가을 on 5/23/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var networkManager = NetworkManager.shared
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        networkManager.delegate = self
        
        setupUI()
    }
    
    func setupUI(){
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        networkManager.fetchArticles()
    }

    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segue.searchSegue, sender: self)
    }

}

extension HomeViewController: NetworkManagerDelegate {
    
    func didUpdateArticles(_ articleManager: NetworkManager, _ articles: ArticleData) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(articles.count)
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        
        cell.titleLabel.text = articles[indexPath.row].title
        cell.descLabel.text = articles[indexPath.row].description
        cell.nameLabel.text = articles[indexPath.row].source.name
        //cell.dateLabel.text = articles[indexPath.row].publishedAt
        
        return cell
    }
    
    
}
