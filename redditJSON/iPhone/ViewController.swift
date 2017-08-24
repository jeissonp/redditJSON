//
//  ViewController.swift
//  redditJSON
//
//  Created by Jeisson on 8/23/17.
//  Copyright © 2017 jeissonp.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var item:Items!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (item != nil) {
            titleLabel.text = item.title
            descriptionTextView.text = item.description
            let name:String = item.id!
            let fileManager = FileManager.default
            
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("icon_\(name).jpg")
            
            if fileManager.fileExists(atPath: imagePath) {
               iconImage.image = UIImage(contentsOfFile: imagePath)!
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

