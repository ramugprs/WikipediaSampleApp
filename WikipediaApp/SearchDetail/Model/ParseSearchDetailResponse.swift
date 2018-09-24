//
//  ParseSearchDetailResponse.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/24/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit

class ParseSearchDetailResponse: NSObject {
    class func parseSearchDetailResponse(response: [String : Any]) -> String{
        if let dict = response["parse"] as? [String: Any]{
            if let parseDict = dict["text"] as? [String: Any]{
                return "\(parseDict["*"] ?? "")"
            }
        }
        return ""
    }
}
