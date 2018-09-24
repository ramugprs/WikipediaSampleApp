//
//  WebServiceHandler.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/23/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit
import Alamofire

class WebServiceHandler: NSObject {
    private static var manager: Alamofire.SessionManager = {
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManagerForDevelop()
        )
        
        return manager
    }()
    
    private class ServerTrustPolicyManagerForDevelop: ServerTrustPolicyManager {
        
        init() {
            super.init(policies: [:])
        }
        
        override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return .disableEvaluation
        }
    }
    
    func GETRequestWithJsonResponse(RequestParam: String, success:@escaping (_ response:Any)-> Void, faliure:@escaping (_ errorMessageCode:String) -> Void){
        
        let escapedString = RequestParam.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        WebServiceHandler.manager.request(escapedString!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                print(response.result.value as Any)   // result of response serialization
                
                if  (response.response?.statusCode == 200 || response.response?.statusCode == 201){
                    
                    if let dict  = response.result.value{
                        success( dict)
                    }else{
                        faliure("No data found")
                    }
                    return
                }
                else{
                    
                    guard response.result.value != nil else{
                        faliure((response.error?.localizedDescription)!)
                        return
                    }
                    
                    faliure("No data found")
                    
                }
        }
    }
}
