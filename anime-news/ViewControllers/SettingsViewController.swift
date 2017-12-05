//
//  SettingsViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/4/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import os.log

class SettingsViewController: UIViewController {
    
    let sections = ["MyAnimeList", "Kitsu", "AniList"]
    let credentialReqs = ["MyAnimeList":["Username"], "Kitsu":["Username"], "AniList":["Client ID", "Client Secret"]]

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

}

extension SettingsViewController: UITableViewDelegate{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "authCellID", for: indexPath)
        
        cell.textLabel?.text = sections[indexPath.row]
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textFields = [UITextField]()
        
        let loginType = sections[indexPath.row]
        // create alertController
        let alertController = UIAlertController(title: "Authentication", message: "Credentials for \(loginType)", preferredStyle: .alert)
        
        credentialReqs[loginType]?.forEach { (label) in
            
            alertController.addTextField { (pTextField) in
                pTextField.placeholder = AdminSettings.shared.MALUsername//label
                pTextField.clearButtonMode = .whileEditing
                pTextField.borderStyle = .none
                textFields.append(pTextField)
            }
        }
        
        
        // create cancel button
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        // create Ok button
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (pAction) in
            // when user taps OK, you get your value here
            textFields.forEach({ (textField) in
                let inputValue = textField.text!
                os_log("%@: Text field input: %@", self.description, inputValue)
                
                if (loginType == "MyAnimeList")
                {
                    AdminSettings.shared.MALUsername = inputValue
                }
            })
            
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        // show alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UIAlertViewDelegate{
    
}

extension SettingsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
}
