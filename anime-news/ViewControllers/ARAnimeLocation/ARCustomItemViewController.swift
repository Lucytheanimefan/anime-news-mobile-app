//
//  ARCustomItemViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 1/4/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import UIKit

class ARCustomItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    
    let pengImage = UIImage(named: "ReachPeng")
    
    let pickerViewImageNames = ["penguinOctopus", "pengCucumber", "pengFriends", "pengDead"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
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
        let index = self.pickerView.selectedRow(inComponent: 0)
        let fileName = self.pickerViewImageNames[index]
        ARAnimeState.shared.animeObject = ARAnimeObject(imageFileName: fileName)
        ARAnimeState.shared.title = self.titleTextView.text
        //print(ARAnimeState.shared.title)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}

extension ARCustomItemViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewImageNames.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
}

extension ARCustomItemViewController: UIPickerViewDelegate{
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        guard row <= self.pickerViewImageNames.count else {
            return view!
        }
        
        let image = UIImage(named: self.pickerViewImageNames[row])
        
        
        let imageView = UIImageView(image: image)

        view?.addSubview(imageView)
        return imageView
        
    }
    
}
