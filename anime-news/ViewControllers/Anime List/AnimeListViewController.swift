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
        self.delegate = self
        
        AnimeListStorage.shared.delegate = self
        self.tableView.addSubview(self.refreshControl)
       
        NotificationCenter.default.addObserver(self, selector: #selector(labelDidChange), name: NSNotification.Name(Constants.Notification.SETTING_CHANGE), object: nil)
        
        if (refreshIntervalTimeUp(recordedDate: AnimeListStorage.shared.lastAPICall))
        {
            #if DEBUG
            os_log("%@: Last API call date difference: %@", self.description, (AnimeListStorage.shared.lastAPICall.timeIntervalSince1970 - Date().timeIntervalSince1970).debugDescription)
            #endif
            fetchInfo()
            loadReviews()
        }

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
        CustomAnimeServer().getReview(animeID: nil) { (review) in
            AnimeListStorage.shared.animeReviews = review
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! MALReviewViewController
        if let cell = sender as? UITableViewCell{
            let selectedIndex = tableView.indexPath(for: cell)!.row
            let anime = AnimeListStorage.shared.animeList[selectedIndex]
            viewController.anime = Anime(id: String(describing: anime["anime_id"]), title: anime["anime_title"] as! String, imagePath: anime["anime_image_path"] as? String, review: nil, status: anime["anime_airing_status"] as? Int)
        }
        
    }

}

extension AnimeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchActive ? filtered.count : AnimeListStorage.shared.animeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MALCellID", for: indexPath) as! MALTableViewCell
        
        guard AnimeListStorage.shared.animeList.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, AnimeListStorage.shared.animeList.count, indexPath.row)
            
            return cell
        }
        
        var tmpAniList:[[String:Any]] = searchActive ? filtered : AnimeListStorage.shared.animeList
        
        let anime = tmpAniList[indexPath.row]
        
        if let title = anime["anime_title"] as? String{
            cell.title.text =  title
            
            if let status = anime["anime_airing_status"] as? Int{
                cell.statusView.createCircle(status: status)
            }
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

extension AnimeListViewController: ReloadViewDelegate{
    func onSet() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
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

extension AnimeListViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = AnimeListStorage.shared.animeList.filter({ (anime) -> Bool in
            var toInclude:Bool = false
            if let title = anime["anime_title"] as? NSString
            {
                let range = title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                toInclude = (range.location != NSNotFound)
            }
            
            return toInclude
        })
        
        searchActive = (filtered.count > 0)
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
}

extension AnimeListViewController: InfoRetrieverDelegate{
    func fetchInfoHandler(completion: @escaping () -> ()) {
        MAL.getAnimeList(status: .all, completion: { (animeList) in
            AnimeListStorage.shared.animeList = animeList
            AnimeListStorage.shared.lastAPICall = Date()
            completion()
        }) { (error) in
            self.presentMessage(title: "Error", message: "Failed to generate MyAnimeList data, using cached data instead")
            completion()
        }
    }
    
    
}
