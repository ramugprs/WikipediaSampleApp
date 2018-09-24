//
//  SearchDetailViewController.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/24/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit
import CoreData

class SearchDetailViewController: UIViewController {
    var networkStatus = WikiNetworkHandler.shared
    @IBOutlet weak var webView: UIWebView!
    var selectedStr: String = ""
    var wikiDetailsManagedObject: NSManagedObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        networkStatus.startNetworkReachabilityObserver()
        networkStatus.delegate = self
        if (WikiNetworkHandler().reachabilityManager?.isReachable)!{
            ReachableNetwork()
        }else{
            NonReachableNetwork()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateObject(detailDescription: String){
        self.webView.loadHTMLString(detailDescription, baseURL: nil)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        wikiDetailsManagedObject?.setValue(detailDescription, forKey: "detailDescription")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not saved. \(error), \(error.userInfo)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchDetailViewController: NetworkStatusDelegate{
    func ReachableNetwork() {
        WikiProgressView.showWaitingDialog("")
        WebServiceLayer().getSerchDetailResults(text: selectedStr, success: { (response) in
            let htmlStr = ParseSearchDetailResponse.parseSearchDetailResponse(response: response)
            
            self.updateObject(detailDescription: htmlStr)
        }) { (errorMessage) in
            WikiProgressView.stopWaitingDialog()
        }
    }
    
    func NonReachableNetwork() {
        self.updateObject(detailDescription: "\(wikiDetailsManagedObject?.value(forKeyPath: "detailDescription") as? String ?? "")")
    }
}
extension SearchDetailViewController: UIWebViewDelegate{
    func webView(_ inWeb: UIWebView, shouldStartLoadWith inRequest: URLRequest, navigationType inType: UIWebViewNavigationType) -> Bool {
        if inType == .linkClicked && !((inRequest.url?.absoluteString as NSString?)?.substring(to: 4) == "file") {
            UIApplication.shared.openURL(inRequest.url!)
            return false
        }
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        //WikiProgressView.showWaitingDialog("")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        WikiProgressView.stopWaitingDialog()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        WikiProgressView.stopWaitingDialog()
    }
}
