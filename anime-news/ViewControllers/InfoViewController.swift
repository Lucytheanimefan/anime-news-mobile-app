//
//  InfoViewController.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/30/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import os.log

protocol InfoRetrieverDelegate {
    func fetchInfoHandler(completion: @escaping () -> ())
    
    func infoStorage() -> Storage
    
    //func viewDidLoadExtras()
}

class InfoViewController: UIViewController {
    
    var delegate:InfoRetrieverDelegate!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var _searchActive:Bool = false
    var searchActive:Bool! {
        get {
            return self._searchActive
        }
        
        set {
            self._searchActive = newValue
            self.tableView.reloadData()
        }
    }
    var filtered:[[String:Any]] = [[String:Any]]()
    
//    lazy var currentList:[[String:Any]] = {
//        return self.searchActive ? self.filtered : self.delegate.infoStorage().listInfo
//    }()
    
    var titleKey:String! = "title"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self as! InfoRetrieverDelegate
        
        self.delegate.infoStorage().delegate = self
        
        self.tableView.addSubview(self.refreshControl)
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (refreshIntervalTimeUp(recordedDate: self.delegate.infoStorage().lastAPICall))
        {
            self.fetchInfo()
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentList() -> [[String:Any]]
    {
         return self.searchActive ? self.filtered : self.delegate.infoStorage().listInfo
    }
    
    func fetchInfo(onFinish: @escaping () -> () = { _ in }){
        guard Reachability.isConnectedToNetwork() else {
            os_log("%@: Not connected to network", self.description)
            onFinish()
            return
        }
        
        delegate.fetchInfoHandler {
            onFinish()
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        os_log("%@: Start refreshing", self.description)
        
        self.fetchInfo {
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
            }
        }
    }

}

extension InfoViewController: ReloadViewDelegate{
    func onSet() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension InfoViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = self.delegate.infoStorage().listInfo.filter({ (news) -> Bool in
            var toInclude:Bool = false
            if let title = news[self.titleKey] as? NSString
            {
                let range = title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                toInclude = (range.location != NSNotFound)
            }
            
            return toInclude
        })
        
        searchActive = (filtered.count > 0)
        
        //sself.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
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

