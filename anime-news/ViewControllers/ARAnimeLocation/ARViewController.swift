//
//  ARViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/2/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    var planes:[UUID: VirtualPlane]! = [UUID: VirtualPlane]()
    var configuration: ARWorldTrackingConfiguration!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSceneView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func initializeSceneView() {
        // Set the view's delegate
        sceneView.delegate = self as? ARSCNViewDelegate
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create new scene and attach the scene to the sceneView
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        
        // Add the SCNDebugOptions options
        // showConstraints, showLightExtents are SCNDebugOptions
        // showFeaturePoints and showWorldOrigin are ARSCNDebugOptions
        //sceneView.debugOptions  = [SCNDebugOptions.showConstraints, SCNDebugOptions.showLightExtents, ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        //shows fps rate
        sceneView.showsStatistics = true
        
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func startSession() {
        configuration = ARWorldTrackingConfiguration()
        //currenly only planeDetection available is horizontal.
        configuration!.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
        sceneView.session.run(configuration!, options: [ARSession.RunOptions.removeExistingAnchors,
                                                        ARSession.RunOptions.resetTracking])
        
    }
    
    func setPlaneTexture(node: SCNNode, imageFilePath:String) {
        if let geometryNode = node.childNodes.first {
            if node.childNodes.count > 0 {
                geometryNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: imageFilePath)
                geometryNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
                geometryNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
                geometryNode.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
                geometryNode.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.linear
            }
        }
    }
    
    
    func stopPlaneDetection(){
        if let configuration = self.sceneView.session.configuration as? ARWorldTrackingConfiguration
        {
            configuration.planeDetection = []
            self.sceneView.session.run(configuration)
        }
    }
    
    // want to shine it down so rotate 90deg around the
    // x-axis to point it down
    func insertSpotlight(position:SCNVector3){
        let spotlight = SCNLight()
        spotlight.type = .spot
        spotlight.spotInnerAngle = 45
        spotlight.spotOuterAngle = 45
        
        let node = SCNNode()
        node.light = spotlight
        node.position = position
        //node.eulerAngles = SCNVector3Make(0, 0, 1)
        node.eulerAngles = self.sceneView.cameraFacingRotation()//SCNVector3Make(Float(-Double.pi/2), 0, 0)
        //let transform = self.sceneView.session.currentFrame?.camera.transform
        //node.orientation =
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func createTextNode(text:String, extrusionDepth:CGFloat = 0.09, font: UIFont = UIFont(name: "Times", size: 0.09)!, fontColor: UIColor = UIColor.blue) -> SCNNode {
        let material = SCNMaterial()
        material.diffuse.contents = fontColor
        let text = SCNText(string: text, extrusionDepth: extrusionDepth)
        text.font = font
        text.firstMaterial = material
        let textNode = SCNNode(geometry: text)
        textNode.eulerAngles = self.sceneView.textFacingRotation()
        
        // account for the fact that SCNText origin point is positioned at bottom left corner
        let (min, max) = textNode.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        return textNode
    }
    
    func textLayer(title:String, fontSize:CGFloat = 12, color: CGColor = UIColor.green.cgColor) -> CALayer{
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.backgroundColor = UIColor.orange.cgColor
        
        let textLayer = CATextLayer()
        textLayer.frame = layer.bounds
        textLayer.fontSize = fontSize
        textLayer.string = title
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.foregroundColor = color
        textLayer.display()
        layer.addSublayer(textLayer)
        
        return layer
    }
}

extension ARSCNView{
    
    func eulerX() -> Float{
        return (self.session.currentFrame?.camera.eulerAngles.x)!
    }
    
    func eulerY() -> Float{
        return (self.session.currentFrame?.camera.eulerAngles.y)!
    }
    
    func eulerZ() -> Float{
        return (self.session.currentFrame?.camera.eulerAngles.z)!
    }
    
    func cameraFacingRotation() -> SCNVector3{
        return SCNVector3Make(Float.pi/2, 3*Float.pi/2, self.eulerZ())
    }
    
    func textFacingRotation() -> SCNVector3{
        return SCNVector3Make(3*Float.pi/2, Float.pi/2, self.eulerZ())
    }
}

