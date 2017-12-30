//
//  ArticleStorage.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/6/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

protocol ReloadViewDelegate {
    func onSet()
}

class ArticleStorage: NSObject {
    
    var delegate:ReloadViewDelegate?
    
    static let shared = ArticleStorage()
    
    private var _numArticleRows:Int!
    var numArticleRows:Int {
        get {
            if (self._numArticleRows == nil)
            {
                if let data = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.ANN_ARTICLES) as? Data{
                    if let articles = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                        self._numArticleRows = articles.count
                    }
                }
                else
                {
                    self._numArticleRows = 0
                }
            }
            return self._numArticleRows
        }
        
        set {
            if (newValue != self._numArticleRows)
            {
                self._numArticleRows = newValue
                
                self.delegate?.onSet()
            }
        }
    }
    
    private var _articles:[[String:Any]]!// = nil
    
    var articles:[[String:Any]] {
        get {
            if (self._articles == nil)
            {
                let data = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.ANN_ARTICLES) as! Data
                if let articles = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                    self._articles = articles
                    
                    self.delegate?.onSet()
                }
                else
                {
                    self._articles = [[String:Any]]()
                }
            }
            return self._articles
        }
        
        set {
            self._articles = newValue
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: Constants.PreferenceKeys.ANN_ARTICLES)
            
            self.delegate?.onSet()
        }
    }

}
