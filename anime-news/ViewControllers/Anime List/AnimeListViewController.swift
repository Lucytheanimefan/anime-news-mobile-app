//
//  AnimeListViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/1/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import AnimeManager
import os.log

class AnimeListViewController: InfoViewController {

    lazy var MAL:MyAnimeList =
        {
            return MyAnimeList(username: AdminSettings.shared.MALUsername, password: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleKey = "anime_title"

        NotificationCenter.default.addObserver(self, selector: #selector(labelDidChange), name: NSNotification.Name(Constants.Notification.SETTING_CHANGE), object: nil)

        // Try to complete any old failed entries in the request queue
        RequestQueue.shared.delegate = self
        RequestQueue.shared.completeQueuedTasks()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func labelDidChange(notification:Notification){
        if let type = notification.userInfo!["Type"] as? String{
            if type == Constants.PreferenceKeys.MAL_USERNAME{
                fetchInfo()
            }
        }
    }
    
    func loadReviews(){
        os_log("%@: Load reviews", self.description)
        CustomAnimeServer().getReview(animeID: nil) { (reviews) in
            AnimeListStorage.sharedStorage.storeInfo(key: Constants.PreferenceKeys.REVIEWS, value: reviews)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! MALReviewViewController
        if let cell = sender as? UITableViewCell{
            let selectedIndex = tableView.indexPath(for: cell)!.row
            print(self.currentList())
            let anime = self.currentList()[selectedIndex]
            
            if let id = anime["anime_id"] as? Int, let title = anime["anime_title"] as? String {
                viewController.anime = Anime(id: String(describing: id), title: title, imagePath: anime["anime_image_path"] as? String, review: nil, status: anime["anime_airing_status"] as? Int)
            }
            
        }
        
    }

}

extension AnimeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.currentList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MALCellID", for: indexPath) as! MALTableViewCell
        
        guard AnimeListStorage.sharedStorage.listInfo.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, AnimeListStorage.sharedStorage.listInfo.count, indexPath.row)
            
            return cell
        }
        
        //var tmpAniList:[[String:Any]] = searchActive ? filtered : AnimeListStorage.sharedStorage.listInfo
        
        let anime = self.currentList()[indexPath.row]
        
        if let status = anime["anime_airing_status"] as? Int{
            cell.statusView.createCircle(status: status)
        }
        
        // TODO: fix this monster
        if let title = anime["anime_title"] as? String{
            cell.title.text =  title
        }
        else if let title = anime["title"] as? String
        {
            cell.title.text =  title
        }
        else
        {
            cell.textLabel?.text = "No Title"
        }
        
        return cell
    }
}



extension AnimeListViewController: UITableViewDelegate{
    
}

extension AnimeListViewController: RequestQueueDelegate{
    func makeRequest(body: [String : Any]) {
        CustomAnimeServer().updateReview(title: body["title"] as! String, animeID: body["anime_id"] as! String, review: body["review"] as! String, completion: { (response) in
            print(response)
        }) {
            self.presentMessage(title: "Error", message: "Review for \(body["title"] as! String) could not be made")
        }
    }
}

extension AnimeListViewController: UISearchBarDelegate{
    
}

extension AnimeListViewController: InfoRetrieverDelegate{
    func infoStorage() -> Storage {
        return AnimeListStorage.sharedStorage
    }
    
    func fetchInfoHandler(completion: @escaping () -> ()) {
        loadReviews()
        MAL.getAnimeList(status: .all, completion: { (animeList) in
            AnimeListStorage.sharedStorage.listInfo = animeList
            AnimeListStorage.sharedStorage.lastAPICall = Date()
            completion()
        }) { (error) in
            self.presentMessage(title: "Error", message: "Failed to generate MyAnimeList data, using cached data instead")
            completion()
        }
    }
    
    
}
