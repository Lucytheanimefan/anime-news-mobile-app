//
//  RequestQueue.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/18/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import os.log
class RequestQueue: NSObject {
    
    static let shared = RequestQueue()
    
    private var _animeQueue:[[String:Any]]! = [[String:Any]]()
    var animeQueue:[[String:Any]]! {
        get {
            if (self._animeQueue.count < 1){
                if let data = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.REQUEST_QUEUE) as? Data{
                    if let queue = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                        self._animeQueue = queue
                    }
                }
            }
            return self._animeQueue
        }
        set {
            self._animeQueue = newValue
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: Constants.PreferenceKeys.REQUEST_QUEUE)

        }
    }
    
    func appendRequest(request:Anime)
    {
        request.timestamp = Date()
        self.animeQueue.append(request.dict)
        
        #if DEBUG
            os_log("%@: Current queue: %@", self.description, self.animeQueue.debugDescription)
        #endif
    }
    
    func nextRequest() -> Anime{
        return Anime(params: self.animeQueue.removeFirst())
    }
    
    func removeStaleAnime(anime_id:String){
        self.animeQueue = self.animeQueue.filter({ (animeDict) -> Bool in
            return (animeDict["anime_id"] as? String != anime_id)
        })
        os_log("%@: filtered queue: %@", self.description, self.animeQueue.debugDescription)
    }

}
