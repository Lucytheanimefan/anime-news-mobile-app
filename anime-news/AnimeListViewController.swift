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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AnimeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MALCellID", for: indexPath)
        
        guard self.animeList.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, self.animeList.count, indexPath.row)
            
            return cell
        }
        
        let anime = self.animeList[indexPath.row]
        
        if let title = anime["anime_title"] as? String{
            cell.textLabel?.text = title
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
