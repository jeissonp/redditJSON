//
//  ViewControlleriPad.swift
//  redditJSON
//
//  Created by Jeisson on 8/24/17.
//  Copyright © 2017 jeissonp.com. All rights reserved.
//

import UIKit

class ViewControlleriPad: UIViewController {
    var item:Items!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (item != nil) {
            titleLabel.text = item.title
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
