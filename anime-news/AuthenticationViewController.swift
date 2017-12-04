//
//  AuthenticationViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/3/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import os.log

class AuthenticationViewController: UITableViewController {
    
    let sections = ["MyAnimeList", "Kitsu", "AniList"]

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authCellID", for: indexPath)
        cell.textLabel?.text = "TEST"//sections[indexPath.section]
        
        os_log("%@: Cell section: %@, with text: %@", self.description, indexPath.section.description, sections[indexPath.section])
        return cell
    }

}
