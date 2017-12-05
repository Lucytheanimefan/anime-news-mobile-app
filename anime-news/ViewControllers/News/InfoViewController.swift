//
//  InfoViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/29/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import os.log

class InfoViewController: UIViewController {
    
    var myTitle = String()
    
    private var _mainText:String! = ""
    
    var mainText:String!
    
    var url:String!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var urlButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = mainText
        self.titleTextView.text = self.title
        self.urlButton.titleLabel?.text = self.url
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dimiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToURL(_ sender: UIButton) {
        if let url = URL(string:url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            os_log("%@: Not valid url %@", type: .error, self.description, url)
        }
    }
    
    func createLabel(text: String){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = text
        self.view.addSubview(label)
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
