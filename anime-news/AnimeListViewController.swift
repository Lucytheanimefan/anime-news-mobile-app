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
    
    private var _lastAPICall:Date!
    var lastAPICall:Date
    {
        get {
            if (self._lastAPICall == nil)
            {
                if let lastRefresh = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.MAL_LAST_REFRESH) as? Date{
                   self.lastAPICall = lastRefresh
                }
                else
                {
                    return Date().addingTimeInterval(-100000)
                }
            }
            return self._lastAPICall
        }
        
        set {
            self._lastAPICall = newValue
            UserDefaults.standard.set(newValue, forKey: Constants.PreferenceKeys.MAL_LAST_REFRESH)
        }
    }
    
    private var _animeList:[[String:Any]]!
    var animeList:[[String:Any]]
    {
        get {
            if (self._animeList == nil)
            {
                if let data = UserDefaults.standard.object(forKey: "MAL") as? Data{
                    if let animeList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                        self._animeList = animeList
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    else
                    {
                        self._animeList = [[String:Any]]()
                    }
                }
                else
                {
                    self._animeList = [[String:Any]]()
                }
            }
            
            return self._animeList
        }
        
        set {
            self._animeList = newValue
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: "MAL")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var MAL:MyAnimeList =
        {
            return MyAnimeList(username: AdminSettings.shared.MALUsername, password: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(labelDidChange), name: NSNotification.Name(Constants.Notification.SETTING_CHANGE), object: nil)
        
        if (refreshIntervalTimeUp(recordedDate: self.lastAPICall) && Reachability.isConnectedToNetwork())
        {
            os_log("%@: Last API call date difference: %@", self.description, (self.lastAPICall.timeIntervalSince1970 - Date().timeIntervalSince1970).debugDescription)
            generateMAL()
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
    
    func generateMAL(){
        // TODO: don't use my own username
        MAL.getAnimeList(status: .all, completion: { (animeList) in
            self.animeList = animeList
            self.lastAPICall = Date()
        }) { (error) in
            // TODO: handle error
            os_log("%@: Error: %@", self.description, error)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! MALReviewViewController
        if let cell = sender as? UITableViewCell{
            let selectedIndex = tableView.indexPath(for: cell)!.row
            let anime = self.animeList[selectedIndex]
            viewController.title = anime["anime_title"] as? String
            viewController.titleText = anime["anime_title"] as? String
            viewController.status = anime["anime_airing_status"] as? Int
            viewController.url = anime["anime_url"] as? String
            viewController.imagePath = anime["anime_image_path"] as? String
        }
        
    }

}

extension AnimeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MALCellID", for: indexPath) as! MALTableViewCell
        
        guard self.animeList.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, self.animeList.count, indexPath.row)
            
            return cell
        }
        
        let anime = self.animeList[indexPath.row]
        //os_log("%@", anime)
        
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
