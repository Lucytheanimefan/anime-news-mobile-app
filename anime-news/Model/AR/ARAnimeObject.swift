//
//  ARAnimeObject.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/4/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit
import ARKit
import os.log
class ARAnimeObject: NSObject {
    
    var node: SCNNode!
    var title: String!
    
    lazy var clonedNode: SCNNode = {
        return self.node.clone()
    }()
    
    init(imageFileName:String, width:CGFloat = 0.001, height:CGFloat = 0.1, length:CGFloat = 0.1) {
        super.init()
        if let image = UIImage(named: imageFileName){
            self.node = loadNodeObject(image: image, width: width, height: height, length: length)
        }
    }

    init(image:UIImage, width:CGFloat = 0.001, height:CGFloat = 0.1, length:CGFloat = 0.1){
        super.init()
        self.node = loadNodeObject(image: image, width: width, height: height, length: length)
    }

    
    func loadNodeObject(image: UIImage, width:CGFloat, height:CGFloat, length:CGFloat) -> SCNNode
    {
        let box = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = image
        let boxNode = SCNNode()
        boxNode.geometry = box
        return boxNode
    }

}
