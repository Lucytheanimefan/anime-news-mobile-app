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
    
    var animeQueue:[Anime]! = [Anime]()
    
    func appendRequest(request:Anime)
    {
        request.timestamp = Date()
        self.animeQueue.append(request)
    }
    
    func nextRequest() -> Anime{
        return self.animeQueue.removeFirst()
    }
    
    func removeStaleAnime(anime_id:String){
        //let predicate = NSPredicate(format: "anime_id == %@", String(anime_id))
        //let filtered = (self.animeQueue as NSArray).filtered(using: predicate)
        let filtered = self.animeQueue.drop(while: { (anime) -> Bool in
            return anime.anime_id == anime_id
        })
        
        os_log("%@: filtered queue: %@", self.description, filtered.debugDescription)
    }

}
