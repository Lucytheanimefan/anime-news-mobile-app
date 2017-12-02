//
//  Shape.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/2/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

import AnimeManager

class Shape: NSObject {
    
    static let shared = Shape()
    
    func createCircle(status:Int) -> CAShapeLayer{
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 15,y: 15), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        var color:CGColor!
        switch status {
        case MyAnimeList.Status.completed.rawValue:
            color = UIColor.blue.cgColor
            break
        case MyAnimeList.Status.currentlyWatching.rawValue:
            color = UIColor.green.cgColor
            break
        case MyAnimeList.Status.dropped.rawValue:
            color = UIColor.gray.cgColor
            break
        case MyAnimeList.Status.planToWatch.rawValue:
            color = UIColor.orange.cgColor
            break
        default:
            color = UIColor.clear.cgColor
        }
        shapeLayer.fillColor = color
        
        //shapeLayer.strokeColor = UIColor.red.cgColor
        
        //shapeLayer.lineWidth = 3.0
        
        return shapeLayer
        
    }

}


