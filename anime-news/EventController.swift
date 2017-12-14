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
import CoreML

class EventController: NSObject {
    
    
    
    func getEvents(){
        AnimeNewsNetwork.sharedInstance.allArticles(articleType: AnimeNewsNetwork.ANNArticle.NewsRoom.convention) { (events) in
            //os_log("%@: Events: %@", self.description, events)
            for event in events
            {
                if let title = event["title"] as? String{
                    self.parseLocation(title: title)
                }
            }
        }
    }
    
    func parseLocation(title:String){
        let schemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: 0)
        let options:NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.string = title
        tagger.enumerateTags(in: NSMakeRange(0, title.count), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, range, pointer) in
            let token = (title as NSString).substring(with: tokenRange)
            if (tag == NSLinguisticTagPlaceName){
                // Found a location!
                print("\(token): \(tag)")
                // Track the location
                
                LocationManager.shared.trackAnimeLocation(location: token)
            }
           
            
        }
        
    }
    
    func registerEvent(){
        
    }

}
