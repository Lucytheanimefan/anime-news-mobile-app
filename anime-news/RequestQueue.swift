//
//  RequestQueue.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/18/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

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
        let predicate = NSPredicate(format: "anime_id == %@", String(self.anime.anime_id))
        (self.animeQueue as NSArray).filtered(using: predicate)
    }

}
