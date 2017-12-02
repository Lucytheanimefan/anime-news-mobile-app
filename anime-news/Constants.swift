//
//  Constants.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/1/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation

struct Constants {
    struct PreferenceKeys {
        static let LAST_REFRESH = "lastRefresh"
        static let MAL_LAST_REFRESH = "MALLastRefresh"
        
    }
    
    struct DefaultValues {
        static let REFRESH_INTERVAL:Double = 600 // 60 * 10 = 10 minutes
    }
}
