//
//  CoreMLManager.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/6/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit
import Vision
import os.log

protocol CoreMLDelegate{
    func displayClassifications(classifications:String)
    func handleLatestPrediction(objectName:String)
    func sceneViewCapturedImage() -> CVPixelBuffer?
}

class CoreMLManager: NSObject {
    
    static let shared = CoreMLManager()

    var delegate: CoreMLDelegate!
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    
    
    func begin(){
        self.setUpRequest()
        self.loopCoreMLUpdate()
    }
    
    private func setUpRequest(){
        guard let selectedModel = try? VNCoreMLModel(for: Inceptionv3().model) else { // (Optional) This can be replaced with other models on https://developer.apple.com/machine-learning/
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from https://developer.apple.com/machine-learning/ . Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompletionHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
    }
    
    private func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML(imagePixelBuffer: self.delegate.sceneViewCapturedImage())
            
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
    }
    
    private func classificationCompletionHandler(request: VNRequest, error:Error?){
        if (error != nil){
            os_log("%@: Error: %@", type: .error, self.description, error.debugDescription)
            return
        }
        
        guard let observations = request.results else {
            os_log("%@: No results", type: .error, self.description)
            return
        }
        
        // Get Classifications
        let classifications = observations[0...1] // top 2 results
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Print Classifications
//            print(classifications)
//            print("--")
            
            // Display Debug Text on screen
            var debugText:String = ""
            debugText += classifications
            self.delegate.displayClassifications(classifications: debugText)
            
            // Store the latest prediction
            var objectName:String = "…"
            objectName = classifications.components(separatedBy: "-")[0]
            objectName = objectName.components(separatedBy: ",")[0]
            self.delegate.handleLatestPrediction(objectName: objectName)
            
        }
        
    }
    
    private func updateCoreML(imagePixelBuffer: CVPixelBuffer?){
    
        ///////////////////////////
        // Get Camera Image as RGB
        //let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)

        guard imagePixelBuffer != nil else {
            os_log("%@: Pixel buffer is nil", self.description)
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: imagePixelBuffer!)
        // Note: Not entirely sure if the ciImage is being interpreted as RGB, but for now it works with the Inception model.
        // Note2: Also uncertain if the pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - regardless, for now, it still works well with the Inception model.
        
        ///////////////////////////
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        // let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage!, orientation: myOrientation, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        
        ///////////////////////////
        // Run Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
}
