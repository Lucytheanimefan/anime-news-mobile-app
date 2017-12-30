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
}

class InfoViewController: UIViewController {
    
    var delegate:InfoRetrieverDelegate!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchInfo(onFinish: @escaping () -> () = { _ in }){
        guard Reachability.isConnectedToNetwork() else {
            os_log("%@: Not connected to network", self.description)
            onFinish()
            return
        }
        
        delegate.fetchInfoHandler {}
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
