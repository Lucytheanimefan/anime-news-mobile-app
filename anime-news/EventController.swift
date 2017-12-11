//
//  EventController.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/11/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import AnimeManager
import os.log

class EventController: NSObject {
    
    func getEvents(){
        AnimeNewsNetwork.sharedInstance.allArticles(articleType: AnimeNewsNetwork.ANNArticle.NewsRoom.convention) { (events) in
            os_log("%@: Events: %@", self.description, events)
            for event in events
            {
                if let title = event["title"] as? String{
                    self.parseLocation(title: title)
                }
            }
        }
    }
    
    func parseLocation(title:String){
        
    }
    
    func registerEvent(){
        
    }

}
