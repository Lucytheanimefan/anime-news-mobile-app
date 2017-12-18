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

    
    var anime:Anime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView.text = self.anime.title
        self.mainTextView.setBorder()
        
        populateReviewText()
        
        self.statusCircleView.createCircle(status: self.anime.status!)
        var label:String!
        switch self.anime.status! {
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
        
        if let imageURL = URL(string:self.anime.imagePath!){
            do {
                self.imageView.image = try UIImage(data: Data(contentsOf: imageURL))
            }
            catch {
                os_log("%@: Error loading image: %@",  type: .error, self.description, self.anime.imagePath!)
            }
        }
        else
        {
            os_log("%@: Error loading image: %@",  type: .error, self.description, self.anime.imagePath!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        guard self.mainTextView.text != "" else {
            os_log("%@: No review to update %@ with", self.description, self.anime.title)
            return
        }
        
        self.anime.review = self.mainTextView.text!
        
        CustomAnimeServer().updateReview(title: self.anime.title, animeID: self.anime.anime_id, review: self.anime.review!, completion: { (response) in
            os_log("%@: Response: %@", self.description, response)
            
            if (response == "success")
            {
                RequestQueue.shared.removeStaleAnime(anime_id: self.anime.anime_id)
                self.presentSuccess(message: "Updated \(anime.title)")
            }
            // Update anime list storage
        }, errorcompletion:
            {
                os_log("%@: Request failed, append %@ to queue", self.description, self.anime.description)
                RequestQueue.shared.appendRequest(request: self.anime)
        })
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func populateReviewText(){
        let predicate = NSPredicate(format: "anime_id == %@", String(self.anime.anime_id))
        let filtered = (AnimeListStorage.shared.animeReviews as NSArray).filtered(using: predicate)
        if (filtered.count > 0) {
            let filteredAnime = filtered[0]
            
            //os_log("%@: Filtered reviews: %@", self.description, filtered.description)
            if let animeData = filteredAnime as? [String:Any] {
                if let review = animeData["review"] as? String{
                    DispatchQueue.main.async {
                        self.mainTextView.text = review
                    }
                }
            }
        }
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
