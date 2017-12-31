//
//  AnimeListStorage.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/6/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class AnimeListStorage: Storage {
    
    static let sharedStorage:Storage =  Storage(lastRefresh: Constants.PreferenceKeys.MAL_LAST_REFRESH, info: Constants.PreferenceKeys.MAL)
    
    class func setReviews(value:[[String:Any]]){
        AnimeListStorage.sharedStorage.storeInfo(key: Constants.PreferenceKeys.REVIEWS, value: value)
    }
    
    class func reviews() -> [[String:Any]]{
        return AnimeListStorage.sharedStorage.getInfo(key: Constants.PreferenceKeys.REVIEWS)
    }
    
}
