//
//  ViewControllerExtension.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/18/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
//    func presentSuccess(message:String){
//        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func presentMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{(alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
