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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
