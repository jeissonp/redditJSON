//
//  TableViewController.swift
//  redditJSON
//
//  Created by Jeisson on 8/23/17.
//  Copyright © 2017 jeissonp.com. All rights reserved.
//

import UIKit
import Foundation

import Alamofire
import SCLAlertView
import MBProgressHUD
import SwiftyJSON


class TableViewController: UITableViewController {
    var indexSelected:Int = 0
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    
    @IBOutlet var tableJSON: UITableView!
    
    var items: [Items] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getDataWeb()
        getDataLocal()
    }
    
    func getDataWeb() {
        showLoadingHUD()
        Alamofire.request("https://www.reddit.com/reddits.json").responseJSON { response in
            self.hideLoadingHUD()
            
            switch response.result {
            case .success(let data):
                let swiftyJsonVar = JSON(data)
                if let resData = swiftyJsonVar["data"]["children"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for index in 0...(self.arrRes.count - 1) {
                        
                        let item = Items(context: self.context) // Link Task & Context
                        let dict = self.arrRes[index]
                        let data = dict["data"] as! [String:AnyObject]
                        
                        item.id = data["id"] as? String
                        item.text = data["public_description"] as? String
                        item.title = data["title"] as? String
                        
                        if let icon = data["icon_img"] as? String {
                            item.icon = icon
                        }
                        
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                }
                
            case .failure(let error):
                SCLAlertView().showError("Error", subTitle: "Error al intentar consumir API")
            }
        }
    }
    
    func getDataLocal() {
        do {
            items = try context.fetch(Items.fetchRequest())
            
            if items.count > 0 {
                tableJSON.reloadData()
            }
        }
        catch {
            SCLAlertView().showError("Error", subTitle: "Fetching Failed")
        }
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as? TableViewCell
        let item = items[indexPath.row]
        cell?.itemLabel.text = item.title
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        
        if let itemUrl = item.icon {
            if !itemUrl.isEmpty {
                let name:String = item.id!
                let fileManager = FileManager.default
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("icon_\(name).jpg")
                
                if !fileManager.fileExists(atPath: imagePath) {
                    let url:URL! = URL(string: itemUrl)
                    let task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                        if let data = try? Data(contentsOf: url){
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                if let updateCell = self.tableView.cellForRow(at: indexPath) as? TableViewCell {
                                    let img:UIImage! = UIImage(data: data)
                                    
                                    let fileManager = FileManager.default
                                    
                                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("icon_\(name).jpg")
                                    
                                    fileManager.createFile(atPath: paths as String, contents: data, attributes: nil)
                                    
                                    updateCell.itemImage.image = img
                                }
                            })
                        }
                    })
                    task.resume()
                }
                else {
                    let img:UIImage = UIImage(contentsOfFile: imagePath)!
                    cell?.itemImage.image = img
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected = (indexPath as NSIndexPath).row
        self.performSegue(withIdentifier: "goDetail", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "goDetail") {
            let vc:ViewController = segue.destination as! ViewController
            
        }
    }
 

}
