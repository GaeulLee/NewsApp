//
//  SavedArticlesViewController.swift
//  NewsApp
//
//  Created by 이가을 on 5/23/24.
//

import UIKit
import SafariServices

class SavedArticlesViewController: UIViewController {

    @IBOutlet weak var savedTableView: UITableView!
    
    var coreDataManager = CoreDataManager.shared
    var articles: [ArticleModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        articles = coreDataManager.getArticleListFromCoreData()
        savedTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTableView.dataSource = self
        savedTableView.delegate = self
        savedTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }

}


// MARK: - UITableViewDataSource
extension SavedArticlesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(#function)
        //print("count: \(articles.count)")
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        
        cell.titleLabel.text = articles[indexPath.row].title
        cell.descLabel.text = articles[indexPath.row].desc
        cell.nameLabel.text = articles[indexPath.row].name
        cell.dateLabel.text = articles[indexPath.row].date
        cell.imageUrl = articles[indexPath.row].imageUrl
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
}

extension SavedArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            self.coreDataManager.deleteArticle(titleToDelete: self.articles[indexPath.row].title!)
            self.articles = self.coreDataManager.getArticleListFromCoreData()
            
            DispatchQueue.main.async {
                self.savedTableView.reloadData()
            }
            
            success(true)
        }
        delete.backgroundColor = .systemPink
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selceted")
        
        guard let url = self.articles[indexPath.row].url, let urlForUse = URL(string: url) else { return }
        
        let safariViewController = SFSafariViewController(url: urlForUse)
        present(safariViewController, animated: true, completion: nil)
    }
    
}
