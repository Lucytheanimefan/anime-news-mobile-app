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
    
    
    
    private var _numArticleRows:Int!
    var numArticleRows:Int {
        get {
            if (self._numArticleRows == nil)
            {
                if let data = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.ANN_ARTICLES) as? Data{
                    if let articles = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                        self._numArticleRows = articles.count
                    }
                }
                else
                {
                    self._numArticleRows = 0
                }
            }
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
    
    private var _articles:[[String:Any]]!// = nil
    
    var articles:[[String:Any]] {
        get {
            if (self._articles == nil)
            {
                let data = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.ANN_ARTICLES) as! Data
                if let articles = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]]{
                    self._articles = articles
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                else
                {
                    self._articles = [[String:Any]]()
                }
            }
            return self._articles
        }
        
        set {
            self._articles = newValue
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: Constants.PreferenceKeys.ANN_ARTICLES)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestPermissions()
        
        if let lastRefresh = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.LAST_REFRESH) as? Date{
            os_log("%@: Last refreshed %@", self.description, lastRefresh.debugDescription)
            
            if (refreshIntervalTimeUp(recordedDate: lastRefresh) && Reachability.isConnectedToNetwork())
            {
                self.fetchArticles()
            }
            else
            {
                #if DEBUG
                    os_log("%@: Too soon to refresh", self.description)
                #endif
            }
        }
        else
        {
            self.fetchArticles()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshNews(_ sender: UIRefreshControl) {
        
        os_log("%@: REFRESH", self.description)
        self.fetchArticles {
            os_log("%@: DONE REFRESHING", self.description)
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        }
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
        
        guard self.articles.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, self.articles.count, indexPath.row)
            
            return cell
        }
        
        let article = self.articles[indexPath.row]
        //os_log("Article: %@", article)
        
        if let title = article["title"] as? String{
            cell.textLabel?.text = title
            if let link = article["link"] as? String{
                let components = link.components(separatedBy: "/")
                let type = components[3]
                //os_log("Type: %@", type)
                if (type == "review")
                {
                    cell.backgroundColor = UIColor.blue
                    cell.textLabel?.textColor = UIColor.white
                }
//                else if (type == "news")
//                {
//                    cell.backgroundColor = UIColor.darkGray
//                    cell.textLabel?.textColor = UIColor.white
//                }
                else if (type == "interest")
                {
                    cell.backgroundColor = UIColor.yellow
                    cell.textLabel?.textColor = UIColor.black
                }
                else
                {
                    cell.backgroundColor = UIColor.white
                    cell.textLabel?.textColor = UIColor.black
                }
            }
        }
        else
        {
            cell.textLabel?.text = "No Title"
        }
        return cell
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchArticles(onFinish: @escaping () -> () = { _ in }){
        AnimeNewsNetwork.sharedInstance.allArticles(articleType: AnimeNewsNetwork.ANNArticle.all) { (articles) in
            //os_log("%@: Article result: %@", self.description, articles)
            UserDefaults.standard.set(Date(), forKey: Constants.PreferenceKeys.LAST_REFRESH)
            self.numArticleRows = articles.count
            self.articles = articles
            
            onFinish()
        }
    }
    
    
    // MARK: - UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO
        transitionVC(id: "")
    }

    
    
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
