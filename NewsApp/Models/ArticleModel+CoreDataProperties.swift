//
//  ArticleModel+CoreDataProperties.swift
//  NewsApp
//
//  Created by 이가을 on 5/29/24.
//
//

import Foundation
import CoreData


extension ArticleModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleModel> {
        return NSFetchRequest<ArticleModel>(entityName: "ArticleModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var desc: String?
    @NSManaged public var title: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var date: String?
    @NSManaged public var savedDate: Date?

}

extension ArticleModel : Identifiable {

}
