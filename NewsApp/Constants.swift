//
//  Constants.swift
//  NewsApp
//
//  Created by 이가을 on 5/27/24.
//

import Foundation

struct K {
    static let appName = "⚡️FlashChat"
    static let apiKey = "e95326ef24e648b3b238ee7f8d0a92b4"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "ArticleTableViewCell"
    
    struct Segue {
        static let searchSegue = "HomeToSearch"
        //static let loginSegue = "LoginToChat"
    }
    
    struct Category {
        
    }
    
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
