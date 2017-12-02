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
    
    let MAL:MyAnimeList = MyAnimeList(username: "Silent_Muse", password: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateMAL()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func generateMAL(){
        // TODO: don't use my own username
        MAL.getAnimeList(status: .all, completion: { (animeList) in
            self.animeList = animeList
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
        os_log("%@", anime)
        
        if let title = anime["anime_title"] as? String{
            cell.title.text =  title
        }
        else
        {
            cell.textLabel?.text = "No Title"
        }
        
        if let status = anime["anime_airing_status"] as? Int{
            cell.statusView.createCircle(status: status)//layer.addSublayer(Shape.shared.createCircle(status: status))
        }
        return cell
    }
}



extension AnimeListViewController: UITableViewDelegate{
    
}
