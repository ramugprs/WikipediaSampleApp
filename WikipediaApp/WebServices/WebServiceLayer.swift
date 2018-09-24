//
//  WebServiceLayer.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/23/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit

class WebServiceLayer: NSObject {
    func getSerchResults(text: String,success:@escaping(_ response:[String:Any])->Void, failure:@escaping(_ errorMessage:String)->Void){
        let webServiceHandler:WebServiceHandler = WebServiceHandler()
        let requestURL = String(format: SEARCH_LIST_API,text)
        webServiceHandler.GETRequestWithJsonResponse(RequestParam: requestURL, success: { (response) in
            success(response as! [String : Any])
        }) { (errorMessage) in
            failure(errorMessage )
        }
    }
    func getSerchDetailResults(text: String,success:@escaping(_ response:[String:Any])->Void, failure:@escaping(_ errorMessage:String)->Void){
        let webServiceHandler:WebServiceHandler = WebServiceHandler()
        let requestURL = String(format: SEARCH_DETAIL_API,text)
        webServiceHandler.GETRequestWithJsonResponse(RequestParam: requestURL, success: { (response) in
            success(response as! [String : Any])
        }) { (errorMessage) in
            failure(errorMessage )
        }
    }
}
