//
//  Data.swift
//  redditJSON
//
//  Created by Jeisson on 8/23/17.
//  Copyright © 2017 jeissonp.com. All rights reserved.
//

import Foundation
import Alamofire
import SCLAlertView
import MBProgressHUD
import SwiftyJSON
import CoreData

class DataReddit {
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    var items: [Items] = []
    
    func getDataWeb(view:UIView) {
        showLoadingHUD(view: view)
        Alamofire.request("https://www.reddit.com/reddits.json").responseJSON { response in
            self.hideLoadingHUD(view: view)
            
            switch response.result {
            case .success(let data):
                let swiftyJsonVar = JSON(data)
                if let resData = swiftyJsonVar["data"]["children"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for index in 0...(self.arrRes.count - 1) {
                        let dict = self.arrRes[index]
                        let data = dict["data"] as! [String:AnyObject]
                        if let id = data["id"] as? String {
                            if !self.checkItem(id: id, context: self.context) {
                                let item = Items(context: self.context) // Link Task & Context
                                item.id = id
                                item.text = data["public_description"] as? String
                                item.title = data["title"] as? String
                                
                                if let icon = data["icon_img"] as? String {
                                    item.icon = icon
                                }
                                
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            }
                        }
                    }
                }
                
            case .failure(let _):
                SCLAlertView().showError("Error", subTitle: "Error al intentar consumir API")
            }
        }
    }
    
    func checkItem(id:String, context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
        let predicateID = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicateID
        
        do {
            
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                return true
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    func getDataLocal() -> [Items] {
        do {
            items = try context.fetch(Items.fetchRequest())
        }
        catch {
            SCLAlertView().showError("Error", subTitle: "Fetching Failed")
        }
        return items
    }
    
    private func showLoadingHUD(view:UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD(view:UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
