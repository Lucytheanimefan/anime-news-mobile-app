//
//  Constants.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/1/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation

struct Constants {
    
    static let MAL = "MyAnimeList"
    
    struct PreferenceKeys {
        static let LAST_REFRESH = "lastRefresh"
        static let MAL_LAST_REFRESH = "MALLastRefresh"
        static let ANN_ARTICLES = "ANNArticles"
        static let MAL_USERNAME = "MALUsername"
        
    }
    
    struct DefaultValues {
        static let REFRESH_INTERVAL:Double = 600 // 60 * 10 = 10 minutes
    }
    
    struct Notification {
        static let SETTING_CHANGE = "changedSetting"
    }
    
    
}
