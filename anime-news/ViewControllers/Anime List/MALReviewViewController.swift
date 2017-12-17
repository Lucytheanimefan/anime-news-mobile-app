//
//  MALReviewViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/2/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import AnimeManager
import os.log

class MALReviewViewController: UIViewController {
    @IBOutlet weak var statusCircleView: ShapeView!
    
    @IBOutlet weak var titleView: UITextView!
    
    @IBOutlet weak var mainTextView: UITextView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var url:String!
    var titleText:String!
    //var mainText:String!
    var status:Int!
    var imagePath:String!
    var animeID:Int! // Not using yet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView.text = self.titleText
        self.mainTextView.setBorder()
        
        populateReviewText()
        
        self.statusCircleView.createCircle(status: self.status)
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
        
        if let imageURL = URL(string:self.imagePath){
            do {
            self.imageView.image = try UIImage(data: Data(contentsOf: imageURL))
            }
            catch {
                os_log("%@: Error loading image: %@",  type: .error, self.description, self.imagePath)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        CustomAnimeServer().updateReview(title: self.titleText!, animeID: String(self.animeID), review: self.mainTextView.text!) { (response) in
            os_log("%@: Response: %@", self.description, response)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func populateReviewText(){
        let predicate = NSPredicate(format: "anime_id == %@", String(self.animeID))
        let filtered = (AnimeListStorage.shared.animeReviews as NSArray).filtered(using: predicate)
        os_log("%@: Filtered reviews: %@", self.description, filtered)
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


extension UITextView{
    func setBorder(color:UIColor = .black, borderWidth:Float = 2){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
    }
}
