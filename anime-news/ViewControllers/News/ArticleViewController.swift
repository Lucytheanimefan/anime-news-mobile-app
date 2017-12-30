//
//  InfoViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/29/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import os.log

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var urlButton: UIButton!
    
    var article:Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = article.summary
        self.titleTextView.text = article.title
        self.urlButton.titleLabel?.text = article.link
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dimiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToURL(_ sender: UIButton) {
        if let url = URL(string:article.link){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            os_log("%@: Not valid url %@", type: .error, self.description, article.link)
        }
    }
    
    func createLabel(text: String){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = text
        self.view.addSubview(label)
    }
    
}
