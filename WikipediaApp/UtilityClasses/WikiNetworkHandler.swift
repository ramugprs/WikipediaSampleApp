//
//  WikiNetworkHandler.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/24/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit
import Alamofire

protocol NetworkStatusDelegate : class{
    func ReachableNetwork()
    func NonReachableNetwork()
}
class WikiNetworkHandler: NSObject {
    var delegate:NetworkStatusDelegate?
    static let shared = WikiNetworkHandler()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    func startNetworkReachabilityObserver() {
        // start listening
        if (UIApplication.shared.applicationState == .inactive) {
            return
        }
        
        reachabilityManager?.listener = { status in
            
            switch status {
            case .notReachable:
                self.delegate?.NonReachableNetwork()
                break
            case .unknown : break
            case .reachable(.ethernetOrWiFi):
                self.delegate?.ReachableNetwork()
                break
            case .reachable(.wwan):
                self.delegate?.ReachableNetwork()
                break
            }
        }
        
        reachabilityManager?.startListening()
    }
}
