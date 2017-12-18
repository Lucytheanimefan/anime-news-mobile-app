//
//  Anime.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/18/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class Anime: NSObject {
    
    var title:String!
    var anime_id:String!
    var review:String?
    var imagePath:String?
    var status:Int?
    
    var timestamp:Date?
    
//    overide var debugDescription: String = {
//        return String(describing: ["anime-id":self.anime_id, "review":self.review, "title":self.title])
//    }
    
    lazy var dict:[String:Any] = {
        return ["anime_id":self.anime_id, "review":self.review, "title":self.title]
    }()
    
    convenience init(id:String, title:String, imagePath:String?, review:String?, status:Int?) {
        self.init()
        self.anime_id = id
        self.title = title
        self.review = review
        self.imagePath = imagePath
        self.status = status
    }
    
    

}
