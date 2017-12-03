//
//  Utilities.swift
//  anime-news
//
//  Created by Lucy Zhang on 4/25/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation

func refreshIntervalTimeUp(recordedDate:Date) -> Bool
{
    return recordedDate.addingTimeInterval(Constants.DefaultValues.REFRESH_INTERVAL) < Date()
}
