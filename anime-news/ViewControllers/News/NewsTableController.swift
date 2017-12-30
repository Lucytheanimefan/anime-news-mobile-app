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

class NewsTableController: /*UITableViewController*/ InfoViewController {
    
    var searchActive:Bool = false
    
    var filtered:[[String:Any]]!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //@IBOutlet weak var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        ArticleStorage.shared.delegate = self
        
        self.tableView.addSubview(self.refreshControl)
        
        if let lastRefresh = UserDefaults.standard.object(forKey: Constants.PreferenceKeys.LAST_REFRESH) as? Date{
            #if DEBUG
            os_log("%@: Last refreshed %@", self.description, lastRefresh.debugDescription)
            #endif
            
            if (refreshIntervalTimeUp(recordedDate: lastRefresh))
            {
                self.fetchInfo()
            }
        }
        else
        {
            self.fetchInfo()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    
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

    
    
    // MARK: - UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO
        transitionVC(id: "")
    }

 
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ArticleViewController
        if let cell = sender as? UITableViewCell{
            let selectedIndex = tableView.indexPath(for: cell)!.row
            let articleData = ArticleStorage.shared.articles[selectedIndex]
            let article = Article(params: articleData)
            viewController.article = article

        }
    }
}

extension NewsTableController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchActive ? filtered.count : ArticleStorage.shared.numArticleRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tmpArticles:[[String:Any]] = searchActive ? filtered : ArticleStorage.shared.articles
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsId", for: indexPath)
        
        guard tmpArticles.count > indexPath.row else {
            os_log("%@: Article count (%@) less than row count (%@)", type: .error, self.description, tmpArticles.count, indexPath.row)
            
            return cell
        }
        
        let articleData = tmpArticles[indexPath.row]
        let article = Article(params: articleData)
        
        cell.textLabel?.text = article.title
        cell.backgroundColor = article.color
        
        return cell
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
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = ArticleStorage.shared.articles.filter({ (news) -> Bool in
            var toInclude:Bool = false
            if let title = news["title"] as? NSString
            {
                let range = title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                toInclude = (range.location != NSNotFound)
            }
            
            return toInclude
        })
        
        searchActive = (filtered.count > 0)

        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
}

extension NewsTableController: InfoRetrieverDelegate{
    func fetchInfoHandler(completion: @escaping () -> ()) {
        AnimeNewsNetwork.sharedInstance.allArticles(articleType: AnimeNewsNetwork.ANNArticle.all) { (articles) in
            //os_log("%@: Article result: %@", self.description, articles)
            UserDefaults.standard.set(Date(), forKey: Constants.PreferenceKeys.LAST_REFRESH)
            ArticleStorage.shared.numArticleRows = ArticleStorage.shared.articles.count
            ArticleStorage.shared.articles = articles
            
            completion()
        }
    }
    
    
}
