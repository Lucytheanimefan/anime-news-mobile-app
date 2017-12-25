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
    
    private var _link:String = ""
    
    var link:String {
        get{
            return self._link
        }
        set {
            let attributedStr = NSAttributedString(string: (newValue).trimmingCharacters(in: .whitespacesAndNewlines))
            self._link = attributedStr.trailingNewlineChopped.string
            
            // Set type based on url
            let components = newValue.components(separatedBy: "/")
            self.type = components[3]
        }
    }
    
    var summary:String?
    var color:UIColor?
    
    private var _type:String!
    var type:String {
        set {
            self._type = newValue
            switch newValue {
            case "review":
                self.color = UIColor.green
                break
            case "interest":
                self.color = UIColor.yellow
                break
            default:
                self.color = UIColor.white
            }
        }
        get {
            return self._type
        }
    }
    
    lazy var dict:[String:Any] = {
        return ["title":self.title, "link":self.link, "description":self.summary!]
    }()
    
    
    convenience init(title:String, link:String, description:String) {
        self.init()
        self.title = title
        self.link = link
        self.summary = description
    }
    
    convenience init(params:[String:Any]) {
        self.init()
        if let title = params["title"] as? String{
            self.title = title
        }
        if let link = params["link"] as? String{
            self.link = link
        }
        if let summary = params["description"] as? String{
            self.summary = summary
        }
    }
    
    

}


