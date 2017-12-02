//
//  MALReviewViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/2/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import AnimeManager
class MALReviewViewController: UIViewController {

    @IBOutlet weak var titleView: UITextView!
    
    @IBOutlet weak var mainTextView: UITextView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var url:String!
    var titleText:String!
    var mainText:String!
    var status:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView.text = self.titleText
     
        var label:String!
        switch self.status {
        case MyAnimeList.Status.completed.rawValue:
            label = "Completed"
            break
        case MyAnimeList.Status.currentlyWatching.rawValue:
            label = "Currently Watching"
            break
        default:
            label = "No known status"
        }
        self.statusLabel.text = label

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
