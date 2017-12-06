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
    
    let sections = ["Accounts", "Database", "Other"]
    let sectionRows = ["Accounts": [Constants.MAL, "Kitsu", "AniList"], "Database":["URI"], "Other":["Anime event notifications"]]
    //let accountRows = ["MyAnimeList", "Kitsu", "AniList"]
    let credentialReqs = [Constants.MAL:["Username"], "Kitsu":["Username"], "AniList":["Client ID", "Client Secret"]]

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         let section = sections[section]
        return (sectionRows[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        let section = sections[indexPath.section]
        let rowTitle = sectionRows[section]?[indexPath.row]
        if (indexPath.section < 2){
            cell = tableView.dequeueReusableCell(withIdentifier: "authCellID", for: indexPath)
            cell.textLabel?.text = rowTitle
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "switchFieldID", for: indexPath) as! SwitchTableViewCell
            (cell as! SwitchTableViewCell).delegate = self
        }
         cell.textLabel?.text = rowTitle
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textFields = [UITextField]()
        let section = sections[indexPath.section]
        let loginType = sectionRows[section]![indexPath.row]
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
                
                if (loginType == Constants.MAL)
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
    
}

extension SettingsViewController:SwitchCellDelegate{
    func switchOn() {
        os_log("%@: Switch on", self.description)
    }
    
    func switchOff() {
        os_log("%@: Switch off", self.description)
    }
}
