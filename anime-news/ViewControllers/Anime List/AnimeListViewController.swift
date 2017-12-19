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

class AnimeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    lazy var MAL:MyAnimeList =
        {
            return MyAnimeList(username: AdminSettings.shared.MALUsername, password: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AnimeListStorage.shared.delegate = self
        self.tableView.addSubview(self.refreshControl)
       
        NotificationCenter.default.addObserver(self, selector: #selector(labelDidChange), name: NSNotification.Name(Constants.Notification.SETTING_CHANGE), object: nil)
        
        if (refreshIntervalTimeUp(recordedDate: AnimeListStorage.shared.lastAPICall) && Reachability.isConnectedToNetwork())
        {
            
            #if DEBUG
            os_log("%@: Last API call date difference: %@", self.description, (AnimeListStorage.shared.lastAPICall.timeIntervalSince1970 - Date().timeIntervalSince1970).debugDescription)
            #endif
            generateMAL()
            loadReviews()

        }
        else
        {
            #if DEBUG
                os_log("%@: Too soon to refresh", self.description)
            #endif

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func labelDidChange(notification:Notification){
        if let type = notification.userInfo!["Type"] as? String{
            if type == Constants.PreferenceKeys.MAL_USERNAME{
                generateMAL()
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        os_log("%@: Start refreshing", self.description)
        self.generateMAL {
            os_log("%@: Done refreshing", self.description)
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
            }
        }
    }
    
    func generateMAL(onFinish: @escaping () -> () = { _ in }){
        // TODO: don't use my own username
        MAL.getAnimeList(status: .all, completion: { (animeList) in
            AnimeListStorage.shared.animeList = animeList
            AnimeListStorage.shared.lastAPICall = Date()
            onFinish()
        }) { (error) in
            // TODO: handle error
            os_log("%@: Error: %@", self.description, error)
            self.presentMessage(title: "Error", message: "Failed to generate MyAnimeList data, using cached data instead")
            onFinish()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimeListStorage.shared.animeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MALCellID", for: indexPath) as! MALTableViewCell
        
        guard AnimeListStorage.shared.animeList.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, AnimeListStorage.shared.animeList.count, indexPath.row)
            
            return cell
        }
        
        let anime = AnimeListStorage.shared.animeList[indexPath.row]
        
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
