//
//  AnimeListStorage.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/6/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class AnimeListStorage: NSObject {
    static let shared = AnimeListStorage()
    
    var delegate:ReloadViewDelegate!
    
    private var _lastAPICall:Date!
    var lastAPICall:Date
    {
        get {
            if (self._lastAPICall == nil)
            {
                if let lastRefresh = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.MAL_LAST_REFRESH) as? Date{
                    self.lastAPICall = lastRefresh
                }
                else
                {
                    return Date().addingTimeInterval(-100000)
                }
            }
            return self._lastAPICall
        }
        
        set {
            self._lastAPICall = newValue
            UserDefaults.standard.set(newValue, forKey: Constants.PreferenceKeys.MAL_LAST_REFRESH)
        }
    }
    
    private var _animeList:[[String:Any]]!
    var animeList:[[String:Any]]
    {
        get {
            if (self._animeList == nil)
            {
                if let data = UserDefaults.standard.object(forKey: "MAL") as? Data{
                    if let animeList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                        self._animeList = animeList
                        
                        delegate.onSet()
                    }
                    else
                    {
                        self._animeList = [[String:Any]]()
                    }
                }
                else
                {
                    self._animeList = [[String:Any]]()
                }
            }
            
            return self._animeList
        }
        
        set {
            self._animeList = newValue
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: "MAL")
            delegate.onSet()
        }
    }
    
    private var _animeReviews:[[String:Any]]!
    var animeReviews:[[String:Any]]
    {
        get {
            if (self._animeReviews == nil)
            {
                if let data = UserDefaults.standard.object(forKey: "animeReviews") as? Data{
                    if let animeReviews = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                        self._animeReviews = animeReviews
                        
                        delegate.onSet()
                    }
                    else
                    {
                        self._animeReviews = [[String:Any]]()
                    }
                }
                else
                {
                    self._animeReviews = [[String:Any]]()
                }
            }
            
            return self._animeReviews
        }
        
        set {
            self._animeReviews = newValue
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: "animeReviews")
            delegate.onSet()
        }
    }
}
