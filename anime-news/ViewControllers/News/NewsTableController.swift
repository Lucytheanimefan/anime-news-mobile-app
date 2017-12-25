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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArticleStorage.shared.delegate = self
        
        if let lastRefresh = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.LAST_REFRESH) as? Date{
            #if DEBUG
            os_log("%@: Last refreshed %@", self.description, lastRefresh.debugDescription)
            #endif
            
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
    
    func initSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        
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
        return ArticleStorage.shared.numArticleRows//self.numArticleRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsId", for: indexPath)
        
        guard ArticleStorage.shared.articles.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, ArticleStorage.shared.articles.count, indexPath.row)
            
            return cell
        }
        
        let articleData = ArticleStorage.shared.articles[indexPath.row]
        let article = Article(params: articleData)

        cell.textLabel?.text = article.title
        cell.backgroundColor = article.color

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
            ArticleStorage.shared.numArticleRows = ArticleStorage.shared.articles.count
            ArticleStorage.shared.articles = articles
            
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
            let articleData = ArticleStorage.shared.articles[selectedIndex]
            let article = Article(params: articleData)
            viewController.article = article

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

extension NewsTableController: ReloadViewDelegate{
    func onSet() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension NewsTableController: UISearchBarDelegate{
    
}

extension NewsTableController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //TODO
    }
}
