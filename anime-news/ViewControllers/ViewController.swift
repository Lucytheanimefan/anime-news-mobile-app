//
//  ViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/25/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var myTitle = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        createLabel(text: myTitle)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dimiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createLabel(text: String){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = text
        self.view.addSubview(label)
    }

}

