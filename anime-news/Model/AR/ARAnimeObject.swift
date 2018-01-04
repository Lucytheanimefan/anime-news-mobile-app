//
//  ARAnimeObject.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/4/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit
import ARKit

class ARAnimeObject: NSObject {
    
    var node: SCNNode!
    var title: String!
    
    init(imageFileName:String) {
        super.init()
        self.node = loadNodeObject(fileName: imageFileName)
    }
    
    func loadNodeObject(fileName:String) -> SCNNode
    {
        let box = SCNBox(width: 0.001, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIImage(named: fileName)
        let boxNode = SCNNode()
        boxNode.geometry = box
        return boxNode
    }

}
