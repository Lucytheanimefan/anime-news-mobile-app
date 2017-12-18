//
//  Article.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/18/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class Article: NSObject {
    var title:String!
    var link:String?
    var summary:String?
    var color:UIColor?
    
    lazy var dict:[String:Any] = {
        return ["title":self.title, "link":self.link!, "description":self.summary!]
    }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(title:String, link:String, description:String) {
        super.init()
        self.title = title
        self.link = link
        self.summary = description
    }

}

class ANNReview:Article {
    override init(title: String, link: String, description: String) {
        super.init(title: title, link: link, description: description)
        self.color = UIColor.blue
    }
}

class ANNInterest:Article {
    
}
