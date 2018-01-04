//
//  ARCustomItemViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/4/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit

class ARCustomItemViewController: UIViewController {

    let pengImage = UIImage(named: "ReachPeng")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ARCustomItemViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return (pengImage?.size.height)!
    }
}

extension ARCustomItemViewController: UIPickerViewDelegate{
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var imageView:UIImageView!
        
        imageView = UIImageView(image: pengImage)
        
        return imageView
        
    }
    
}
