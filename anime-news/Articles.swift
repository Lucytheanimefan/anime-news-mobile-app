//
//  Articles.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/1/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import AnimeManager
import os.log

class Articles: NSObject {
    
    static let sharedInstance = Articles()
    
    var articles:[[String:Any]]!
    
    func processReviews(){
        AnimeNewsNetwork.sharedInstance.allArticles(articleType: AnimeNewsNetwork.ANNArticle.Views.review) { (articles) in
            os_log("%@: Article result: %@", self.description, articles)
            self.articles = articles
        }
    }

}
