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
    
    init(imageFileName:String) {
        super.init()
        if let image = UIImage(named: imageFileName){
            self.node = loadNodeObject(image: image)
        }
    }
    
    init(imageURL:String) {
        super.init()
        
        if let url = URL(string: imageURL){
            let sema = DispatchSemaphore(value: 0)
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                guard error != nil else {
                    os_log("%@: Error with url: %@", self.description, (error?.localizedDescription)!)
                    sema.signal()
                    return
                }
                if (data != nil)
                {
                    if let image = UIImage(data: data!){
                        self.node = self.loadNodeObject(image: image)
                    }
                    sema.signal()
                }
                sema.signal()
            })
            _ = sema.wait(timeout: .distantFuture)
        }
        else
        {
            os_log("%@: Not url: %@", self.description, imageURL)
        }
        
    }
    
    func loadNodeObject(image: UIImage) -> SCNNode
    {
        let box = SCNBox(width: 0.001, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = image
        let boxNode = SCNNode()
        boxNode.geometry = box
        return boxNode
    }

}
