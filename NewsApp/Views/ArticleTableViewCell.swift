//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by 이가을 on 5/27/24.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ImageView.image = nil // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ImageView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func loadImage() {
        ImageView.isHidden = true
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        if !urlString.contains("https://") {
            print("invalid imageUrl ->  \(urlString)")
            return
        }
        
        ImageView.isHidden = false
        
        DispatchQueue.global().async { // 오래 걸리는 작업이기 때문에 다른 스레드에서 동작시킴
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거 ⭐️⭐️⭐️
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.ImageView.image = UIImage(data: data)
            }
        }
    }
    
}
