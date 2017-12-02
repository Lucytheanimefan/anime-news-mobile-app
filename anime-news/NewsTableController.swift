//
//  NewsTableController.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/25/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import AnimeManager
import os.log

class NewsTableController: UITableViewController {
    var anime: [String] = ["Kimi no na wa", "Attack on Titan"]
    
    private var _numArticleRows:Int! = 0
    var numArticleRows:Int {
        get {
            return self._numArticleRows
        }
        
        set {
            if (newValue != self._numArticleRows)
            {
                 self._numArticleRows = newValue
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private var _articles:[[String:Any]] = [[String:Any]]()
    
    var articles:[[String:Any]] {
        get {
            return self._articles
        }
        
        set {
            self._articles = newValue
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.processReviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.numArticleRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsId", for: indexPath)
        
        guard self.articles != nil, self.articles.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, self.articles.count, indexPath.row)
            
            return cell
        }
        
        let article = self.articles[indexPath.row]
        
        if let title = article["title"] as? String{
            cell.textLabel?.text = title
        }
        else
        {
            cell.textLabel?.text = "No Title"
        }
        return cell
    }
    
    func processReviews(){
        AnimeNewsNetwork.sharedInstance.allArticles(articleType: AnimeNewsNetwork.ANNArticle.all) { (articles) in
            os_log("%@: Article result: %@", self.description, articles)
            self.numArticleRows = articles.count
            self.articles = articles
        }
    }
    
    
    // MARK: - UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! InfoViewController
        if let cell = sender as? UITableViewCell{
            let selectedIndex = tableView.indexPath(for: cell)!.row
            let article = self.articles[selectedIndex]
            viewController.title = article["title"] as? String
            viewController.mainText = article["description"] as! String
            let attributedStr = NSAttributedString(string: (article["link"] as! String).trimmingCharacters(in: .whitespacesAndNewlines))
            viewController.url = attributedStr.trailingNewlineChopped.string
        }
        
    }
}

extension NSAttributedString{
    var trailingNewlineChopped: NSAttributedString {
        if self.string.hasSuffix("\n") {
            return self.attributedSubstring(from: NSMakeRange(0, self.length - 1))
        } else {
            return self
        }
    }
}
