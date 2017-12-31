//
//  ArticleStorage.swift
//  anime-news
//
//  Created by Lucy Zhang on 12/6/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit

protocol ReloadViewDelegate {
    func onSet()
}

class ArticleStorage: Storage {

    static let sharedStorage:Storage =  Storage(lastRefresh: Constants.PreferenceKeys.LAST_REFRESH, info: Constants.PreferenceKeys.ANN_ARTICLES)


}
