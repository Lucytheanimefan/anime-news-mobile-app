//
//  AdminSettings.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/4/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class AdminSettings: NSObject {
    static let shared = AdminSettings()
    
    private var _MALUsername:String!
    var MALUsername:String {
        get {
            if (self._MALUsername == nil)
            {
                if let MALUsername = UserDefaults.standard.value(forKey: Constants.PreferenceKeys.MAL_USERNAME) as? String{
                    return MALUsername
                }
                else
                {
                    return "Silent_Muse" // Default MALUsername?
                }
            }
            return self._MALUsername
        }
        set {
            self._MALUsername = newValue
            UserDefaults.standard.set(newValue, forKey: Constants.PreferenceKeys.MAL_USERNAME)
            NotificationCenter.default.post(name: NSNotification.Name(Constants.Notification.SETTING_CHANGE), object: nil, userInfo: ["Type":Constants.PreferenceKeys.MAL_USERNAME])
        }
    }
    
    private var _debugAR:Bool!
    
    var debugAR:Bool {
        get {
            if (self._debugAR == nil)
            {
                if let debugAR = UserDefaults.standard.value(forKey: Constants.PreferenceKeys.DEBUG_AR) as? Bool{
                    self._debugAR = debugAR
                }
                else
                {
                    self._debugAR = false // Default MALUsername?
                }
            }
            return self._debugAR
        }
        
        set {
            self._debugAR = newValue
            UserDefaults.standard.set(self._debugAR, forKey: Constants.PreferenceKeys.DEBUG_AR)
        }
    }
    
    
}
