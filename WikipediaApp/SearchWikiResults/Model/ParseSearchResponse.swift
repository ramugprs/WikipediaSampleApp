//
//  ParseSearchResponse.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/23/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit
import CoreData

class ParseSearchResponse: NSObject {
    class func parseSearchResponse(response: [String : Any]) -> [SearchResultsModel]{
        var searchResultsArray = [SearchResultsModel]()
        if let dict = response["query"] as? [String: Any]{
            if let tmpArray = dict["pages"] as? [[String: Any]], tmpArray.count > 0{
                
                for searchDict in tmpArray {
                    let searchModel = SearchResultsModel()
                    searchModel.title = "\(searchDict["title"] ?? "")"
                    
                    if let thumbnailDict = searchDict["thumbnail"] as? [String: Any]{
                        searchModel.thumbnail = "\(thumbnailDict["source"] ?? "")"
                    }
                    
                    if let termsDict = searchDict["terms"] as? [String: Any]{
                        if let descriptionArray = termsDict["description"]as? [String],descriptionArray.count > 0 {
                            searchModel.descriptionText = descriptionArray[0]
                        }
                    }
                    searchResultsArray.append(searchModel)
                }
            }
        }
        return searchResultsArray
    }
    class func parseSearchResponseForOffline(response: [NSManagedObject]) -> [SearchResultsModel]{
        var searchResultsArray = [SearchResultsModel]()
        
        for wikiDetails in response {
            let searchModel = SearchResultsModel()
            searchModel.title = "\(wikiDetails.value(forKeyPath: "title") as? String ?? "")"
            searchModel.thumbnail = "\(wikiDetails.value(forKeyPath: "thumbnailUrl") as? String ?? "")"
            searchModel.descriptionText = "\(wikiDetails.value(forKeyPath: "descriptionText") as? String ?? "")"
            searchResultsArray.append(searchModel)
        }
        return searchResultsArray
    }
}
