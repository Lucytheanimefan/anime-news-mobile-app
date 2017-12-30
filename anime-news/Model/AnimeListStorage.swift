//
//  AnimeListStorage.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/6/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class AnimeListStorage: Storage {
    
    static let sharedStorage:Storage =  Storage.sharedInstanceWithKeys(lastRefresh: Constants.PreferenceKeys.MAL_LAST_REFRESH, info: Constants.PreferenceKeys.MAL)
    
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
