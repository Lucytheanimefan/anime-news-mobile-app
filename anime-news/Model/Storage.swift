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
    
    var LAST_REFRESH:String!
    var LIST_INFO:String!

    class func sharedInstanceWithKeys(lastRefresh:String, info:String) -> Storage{
        Storage.shared.LAST_REFRESH = lastRefresh
        Storage.shared.LIST_INFO = info
        return Storage.shared
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
                if let data = UserDefaults.standard.object(forKey: self.LIST_INFO) as? Data{
                    if let listInfo = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                        self._listInfo = listInfo
                        
                        delegate.onSet()
                    }
                    else
                    {
                        self._listInfo = [[String:Any]]()
                    }
                }
                else
                {
                    self._listInfo = [[String:Any]]()
                }
            }
            
            return self._listInfo
        }
        
        set {
            self._listInfo = newValue
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: self.LIST_INFO)
            delegate.onSet()
        }
    }
}
