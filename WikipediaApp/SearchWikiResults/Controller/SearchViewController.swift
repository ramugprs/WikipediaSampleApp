//
//  SearchViewController.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/23/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    var resultsArray = [SearchResultsModel]()
    var wikiSavedListForOffline: [NSManagedObject] = []
    var networkStatus = WikiNetworkHandler.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationController?.navigationBar.isTranslucent = false
        
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
    
    @IBAction func textDidChange(_ textField: UITextField){
        WebServiceLayer().getSerchResults(text: textField.text!, success: { (response) in
            
            self.resultsArray = ParseSearchResponse.parseSearchResponse(response: response)
            
            self.deleteOfflineSavedResults()
            for model in self.resultsArray{
                self.saveWikiDetails(title: model.title, description: model.descriptionText, thumbnail: model.thumbnail)
            }
            self.searchResultsTableView.reloadData()
            self.getResultsFromCoreData()
        }) { (errorMessage) in
            
        }
    }
    
    func saveWikiDetails(title: String, description: String, thumbnail: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // create managedContext
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let  entity = NSEntityDescription.entity(forEntityName: "Wikipedia", in: managedContext)!
        
        let wikiDetails = NSManagedObject(entity: entity, insertInto: managedContext)
        
        wikiDetails.setValue(title, forKey: "title")
        wikiDetails.setValue(description, forKey: "descriptionText")
        wikiDetails.setValue(thumbnail, forKey: "thumbnailUrl")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchSavedResultsForOffline(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "Wikipedia")
        
        do {
            wikiSavedListForOffline = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.resultsArray = ParseSearchResponse.parseSearchResponseForOffline(response: wikiSavedListForOffline)
        self.searchResultsTableView.reloadData()
    }
    func getResultsFromCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "Wikipedia")
        
        do {
            wikiSavedListForOffline = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func deleteOfflineSavedResults(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "Wikipedia")
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
    
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
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchCellID", for: indexPath) as! SearchTableViewCell
        let searchModel = resultsArray[indexPath.row]
        let range = NSString(string: searchModel.title).range(of: searchTextField.text!.capitalized)
        let attributedString = NSMutableAttributedString(string: searchModel.title)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
        cell.titleLabel.attributedText = attributedString
        cell.descriptionLabel.text = searchModel.descriptionText
        cell.thumbnail.sd_setImage(with: URL(string: searchModel.thumbnail), placeholderImage:#imageLiteral(resourceName: "placeholder"))
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "SearchDetail", bundle: nil)
        let seachDetailVC: SearchDetailViewController = storyBoard.instantiateViewController(withIdentifier: "SearchDetailVCID") as! SearchDetailViewController
        let searchModel = resultsArray[indexPath.row]
        seachDetailVC.selectedStr = searchModel.title
        if wikiSavedListForOffline.count > 0{
            seachDetailVC.wikiDetailsManagedObject = wikiSavedListForOffline[indexPath.row]
        }
        self.navigationController?.pushViewController(seachDetailVC, animated: false)
    }
}
extension SearchViewController: NetworkStatusDelegate{
    func ReachableNetwork() {
        self.textDidChange(searchTextField)
    }
    
    func NonReachableNetwork() {
        fetchSavedResultsForOffline()
    }
}
extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
