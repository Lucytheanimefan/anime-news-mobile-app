//
//  ARAnimeState.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/4/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit

class ARAnimeState: NSObject {
    
    static let shared = ARAnimeState()
    
    private var _animeObject:ARAnimeObject?
    var animeObject: ARAnimeObject {
        get {
            return (self._animeObject == nil) ? ARAnimeObject(imageFileName: "ReachPeng") : self._animeObject!
        }
        
        set {
            self._animeObject = newValue
        }
    }

}
