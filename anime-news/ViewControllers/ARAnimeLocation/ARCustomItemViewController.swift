//
//  ARCustomItemViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/4/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit

class ARCustomItemViewController: UIViewController {
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var widthField: UITextField!
    
    @IBOutlet weak var heightField: UITextField!
    
    @IBOutlet weak var lengthField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func setObject(_ sender: UIButton) {
        if let width = NumberFormatter().number(from: widthField.text!), let height = NumberFormatter().number(from: heightField.text!), let length = NumberFormatter().number(from: lengthField.text!) {
            let w = CGFloat(width), h = CGFloat(height), l = CGFloat(length)
            
            ARAnimeState.shared.animeObject = ARAnimeObject(image: self.imagePicked.image!, width: w, height: h, length: l)
        }
        else
        {
            ARAnimeState.shared.animeObject = ARAnimeObject(image: self.imagePicked.image!)
        }
        ARAnimeState.shared.title = self.titleTextView.text
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ARCustomItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePicked.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
