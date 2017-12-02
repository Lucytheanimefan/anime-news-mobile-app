//
//  ShapeView.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/2/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import AnimeManager

class ShapeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func createCircle(status:Int)/* -> CAShapeLayer*/{
        let x = self.bounds.size.width/2
        let y = self.bounds.size.height/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: x,y: y), radius: CGFloat(x), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
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
        
        self.layer.addSublayer(shapeLayer)
        //return shapeLayer
        
    }

}
