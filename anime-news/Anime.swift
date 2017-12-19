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
        return ["anime_id":self.anime_id!, "review":self.review, "title":self.title!, "timestamp":self.timestamp]
    }()
    
    convenience init(id:String, title:String, imagePath:String?, review:String?, status:Int?) {
        self.init()
        self.anime_id = id
        self.title = title
        self.review = review
        self.imagePath = imagePath
        self.status = status
    }
    
    convenience init(params:[String:Any]) {
        self.init()
        if let anime_id = params["anime_id"] as? String{
            self.anime_id = anime_id
        }
        if let title = params["title"] as? String{
            self.title = title
        }
        if let review = params["review"] as? String{
            self.review = review
        }
        if let imagePath = params["imagePath"] as? String{
            self.imagePath = imagePath
        }
        if let status = params["status"] as? Int{
            self.status = status
        }
    }
    
    

}
