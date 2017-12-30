//
//  Storage.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/30/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class Storage: NSObject {
    var delegate:ReloadViewDelegate!
    
    static let shared = Storage()
    
    private var _lastAPICall:Date!
    var lastAPICall:Date
    {
        get {
            if (self._lastAPICall == nil)
            {
                if let lastRefresh = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.LAST_REFRESH) as? Date{
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
            UserDefaults.standard.set(newValue, forKey: Constants.PreferenceKeys.LAST_REFRESH)
        }
    }
}
