//
//  HomeViewController.swift
//  NewsApp
//
//  Created by 이가을 on 5/23/24.
//

import UIKit
import SafariServices
import Toast_Swift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seachBar: UISearchBar!
    
    var networkManager = NetworkManager.shared
    var coreDataManager = CoreDataManager.shared
    var articles: [Article] = []
    
    
    // 화면에 다시 진입할때마다 테이블뷰 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        networkManager.fetchArticles()
        tableView.reloadData()
        seachBar.text = ""
        
        view.makeToastActivity(.center)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        networkManager.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        guard let searchWord = searchBar.text, !searchWord.isEmpty else {
            return
        }
        print("searchWord: \(searchWord)")
        
        DispatchQueue.main.async {
            self.view.makeToastActivity(.center)
        }
        networkManager.fetchArticles(searchFor: searchWord)
    }
    
}


// MARK: - NetworkManagerDelegate
extension HomeViewController: NetworkManagerDelegate {
    
    func didUpdateArticles(_ articleManager: NetworkManager, _ updatedArticles: [Article]) {
        self.articles = updatedArticles

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.hideToastActivity()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(#function)
        //print("count: \(articles.count)")
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        
        cell.titleLabel.text = articles[indexPath.row].title
        cell.descLabel.text = articles[indexPath.row].description
        cell.nameLabel.text = articles[indexPath.row].source.name
        cell.dateLabel.text = articles[indexPath.row].date
        cell.imageUrl = articles[indexPath.row].urlToImage
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal, title: "Save") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            self.coreDataManager.saveArticle(articleToSave: self.articles[indexPath.row])
            //print(self.articles[indexPath.row].title)
            self.view.makeToast("Successfully saved an article.", duration: 1.0)
            success(true)
        }
        save.backgroundColor = .systemPink
        save.image = UIImage(systemName: "bookmark.fill")
        
        //actions배열 인덱스 0이 왼쪽에 붙어서 나옴
        return UISwipeActionsConfiguration(actions: [save])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let url = URL(string: self.articles[indexPath.row].url) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
}
