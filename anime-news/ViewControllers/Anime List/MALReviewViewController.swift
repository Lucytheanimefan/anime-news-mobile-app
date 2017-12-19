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
    
    var anime:Anime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView.text = self.anime.title
        self.mainTextView.setBorder()
        
        populateReviewText()
        
        self.statusCircleView.createCircle(status: self.anime.status!)

        self.statusLabel.text = MyAnimeList.statusKey[self.anime.status!]
        
        if (Reachability.isConnectedToNetwork())
        {
            self.setImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImage(){
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
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        guard self.mainTextView.text != "" else {
            os_log("%@:No review to update for %@", self.description, self.anime.title)
            return
        }
        
        guard Reachability.isConnectedToNetwork() else {
            handleFailedServerRequest()
            return
        }
        
        self.anime.review = self.mainTextView.text!
        
        CustomAnimeServer().updateReview(title: self.anime.title, animeID: self.anime.anime_id, review: self.anime.review!, completion: { (response) in
            os_log("%@: Response: %@", self.description, response)
            
            if (response.lowercased() == "success")
            {
                RequestQueue.shared.removeStaleAnime(anime_id: self.anime.anime_id)
                
                // Remove the stale entry
                AnimeListStorage.shared.animeReviews = AnimeListStorage.shared.animeReviews.filter({ (animeDict) -> Bool in
                    return (animeDict["anime_id"] as? String != self.anime.anime_id)
                })
                
                // Add the newly updated anime
                AnimeListStorage.shared.animeReviews.append(self.anime.dict)
                self.presentMessage(title: "Sucess", message:  "Updated \(self.anime.title!)")
                
            }
            else
            {
                self.handleFailedServerRequest()
            }
            // Update anime list storage
        }, errorcompletion: handleFailedServerRequest)
    }
    
    func handleFailedServerRequest()
    {
        self.presentMessage(title: "Error", message: "Failed to update info for \(self.anime.title!), will try again later")
        RequestQueue.shared.appendRequest(request: self.anime)
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
