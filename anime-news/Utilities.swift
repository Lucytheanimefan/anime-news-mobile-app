//
//  Utilities.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/25/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main = "Main"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}


func refreshIntervalTimeUp(recordedDate:Date) -> Bool
{
    return recordedDate.addingTimeInterval(Constants.DefaultValues.REFRESH_INTERVAL) < Date()
}

func transitionVC(id:String){
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    let vc = storyBoard.instantiateViewController(withIdentifier: id)
    
    ((UIApplication.shared.delegate?.window)!)!.rootViewController = vc
}
