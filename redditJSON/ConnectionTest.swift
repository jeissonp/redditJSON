//
//  ConnectionTest.swift
//  redditJSON
//
//  Created by Jeisson on 8/24/17.
//  Copyright © 2017 jeissonp.com. All rights reserved.
//

import Foundation
import Alamofire

public class ConnectionCheck {
    class func isConnectedToNetwork() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
