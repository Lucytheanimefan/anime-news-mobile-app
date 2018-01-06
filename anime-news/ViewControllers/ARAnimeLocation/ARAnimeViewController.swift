//
//  ARAnimeViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/3/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit
import ARKit

class ARAnimeViewController: ARViewController{

    @IBOutlet weak var debugTextView: UITextView!
    
    var anchors = [ARAnchor]()
    // set isPlaneSelected to true when user taps on the anchor plane to select.
    var isPlaneSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CoreMLManager.shared.delegate = self
        CoreMLManager.shared.begin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func selectExistingPlane(location: CGPoint) {
        // Hit test result from intersecting with an existing plane anchor, taking into account the plane’s extent.
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            let result: ARHitTestResult = hitResults.first!
            if let planeAnchor = result.anchor as? ARPlaneAnchor {
                for anchor in anchors {
                    if anchor.identifier != planeAnchor.identifier{
                        sceneView.node(for: anchor)?.removeFromParentNode()
                        sceneView.session.remove(anchor: anchor)
                    }
                }
                
                // keep track of selected anchor only
                anchors = [planeAnchor]
                isPlaneSelected = true
  
            }
        }
    }
    
    // checks if anchors are already created. If created, clones the node and adds it the anchor at the specified location
    func addNodeAtLocation(location: CGPoint) {
        guard anchors.count > 0 else {
            print("anchors are not created yet")
            return
        }
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            
            let node = ARAnimeState.shared.animeObject.node
            let clonedNode = node!.clone()
            clonedNode.eulerAngles = self.sceneView.cameraFacingRotation()
            
            // Deal with offset since centered
            let height = clonedNode.boundingBox.max.y - clonedNode.boundingBox.min.y
            
            let result: ARHitTestResult = hitResults.first!
            
            let textLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y/3, result.worldTransform.columns.3.z)
            let newLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y + height/2, result.worldTransform.columns.3.z)
            
            clonedNode.position = newLocation
            
            sceneView.scene.rootNode.addChildNode(clonedNode)
            
            let titleText = ARAnimeState.shared.title
            if (titleText!.count > 0){
                let textNode = self.createTextNode(text: titleText!, extrusionDepth: 0.02)
                textNode.position = textLocation

                sceneView.scene.rootNode.addChildNode(textNode)
            }
            
        }
    }
    
   
}


extension ARAnimeViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor{
            let plane = VirtualPlane(anchor: arPlaneAnchor)
            if (AdminSettings.shared.debugAR)
            {
                plane.setPlaneMaterial(imageName: "Hardwood")
            }
            else
            {
                plane.noPlane()
            }
            self.planes[arPlaneAnchor.identifier] = plane
            node.addChildNode(plane)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = self.planes[arPlaneAnchor.identifier]{
            plane.updateWithNewAnchor(arPlaneAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: arPlaneAnchor.identifier){
            planes.remove(at: index)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        if !isPlaneSelected {
            selectExistingPlane(location: location)
        } else {
            addNodeAtLocation(location: location)
        }
    }
}

extension ARAnimeViewController: CoreMLDelegate{
    func sceneViewCapturedImage() -> CVPixelBuffer? {
        return (sceneView.session.currentFrame?.capturedImage)
    }
    
    func displayClassifications(classifications: String) {
        self.debugTextView.text = "Classifications: \(classifications)"
    }
    
    func handleLatestPrediction(objectName: String) {
        self.debugTextView.text = "Latest prediction: \(objectName)"
    }
    
    
}
