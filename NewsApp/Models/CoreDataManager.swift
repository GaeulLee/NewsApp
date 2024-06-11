//
//  CoreDataManager.swift
//  NewsApp
//
//  Created by 이가을 on 5/28/24.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // AppDelegate의 persistent containser에서 context를 불러오기
    let appDelegate = UIApplication.shared.delegate as? AppDelegate // AppDelegate 가져오기
    lazy var context = appDelegate?.persistentContainer.viewContext // context(임시 저장소) 가져오기
    
    let modelName: String = "ArticleModel"
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getArticleListFromCoreData() -> [ArticleModel] {
        var articleList: [ArticleModel] = []
        if let context = context { // 임시저장소 있는지 확인
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName) // 요청서
            let dateOrder = NSSortDescriptor(key: "savedDate", ascending: false) // 정렬순서를 정해서 요청서에 넘겨주기
            request.sortDescriptors = [dateOrder]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedArticleList = try context.fetch(request) as? [ArticleModel] {
                    articleList = fetchedArticleList
                }
            } catch {
                print("CoreDataManager - getArticleListFromCoreData: Failed to load saved articles.")
            }
        }
        
        print("Success to load saved articles!")
        return articleList
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveArticle(articleToSave: Article) {
        if let context = context {
            // 중복된 기사 생성 방지
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "title = %@", articleToSave.title as CVarArg)
            
            do {
                if let fetchedArticleList = try context.fetch(request) as? [ArticleModel] {
                    if fetchedArticleList.first != nil {
                        print("Article duplicated.")
                        return
                    }
                }
            } catch {
                print("CoreDataManager - saveArticle: Faild to find article.")
            }
            
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ArticleModel)
                if let article = NSManagedObject(entity: entity, insertInto: context) as? ArticleModel {
                    article.savedDate = Date()
                    article.name = articleToSave.source.name
                    article.title = articleToSave.title
                    article.desc = articleToSave.description
                    article.date = articleToSave.date
                    article.url = articleToSave.url
                    article.imageUrl = articleToSave.urlToImage
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            print("CoreDataManager - saveArticle: Faild to save an article.")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        print("Success to save an article!")
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteArticle(titleToDelete: String) {
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "title = %@", titleToDelete as CVarArg) // 단서 / 찾기 위한 조건 설정
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기)
                if let fetchedArticleList = try context.fetch(request) as? [ArticleModel] {
                    if let targetArticle = fetchedArticleList.first { // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기
                        context.delete(targetArticle)
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            } catch {
                print("Faild to delete an article.")
            }
        }
        print("Success to delete an article!")
    }
    
}
