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
    
    var LAST_REFRESH:String!
    var LIST_INFO:String!

    
    convenience init(lastRefresh:String, info:String) {
        self.init()
        self.LAST_REFRESH = lastRefresh
        self.LIST_INFO = info
    }
    
    private var _lastAPICall:Date!
    var lastAPICall:Date
    {
        get {
            if (self._lastAPICall == nil)
            {
                if let lastRefresh = UserDefaults.standard.object(forKey: self.LAST_REFRESH) as? Date{
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
    
    private var _listInfo:[[String:Any]]!
    var listInfo:[[String:Any]]
    {
        get {
            if (self._listInfo == nil)
            {
                self._listInfo = getInfo(key: self.LIST_INFO)
            }
            
            return self._listInfo
        }
        
        set {
            self._listInfo = newValue
            storeInfo(key: self.LIST_INFO, value: newValue)
            delegate.onSet()
        }
    }
    
    func storeInfo(key:String, value:[[String:Any]]){
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func getInfo(key:String) ->[[String:Any]]{
        if let data = UserDefaults.standard.object(forKey: key) as? Data{
            if let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                return info
            }
        }
        return [[String:Any]]()
    }
}
