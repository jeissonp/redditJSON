//
//  NetController.swift
//  redditJSON
//
//  Created by Jeisson on 8/23/17.
//  Copyright © 2017 jeissonp.com. All rights reserved.
//

import Foundation
class NetController {
    
    static let redditsURL = "https://www.reddit.com/reddits.json"
    
    func load(_ urlString: String, withCompletion completion: @escaping ([Any]?) -> Void) {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                completion(nil)
                return
            }
            let result: [Any]
            switch urlString {
            case NetworkController.questionsURL:
                result = [] // Transform JSON into Question values
            case NetworkController.usersURL:
                result = [] // Transform JSON into Question values
            default:
                result = []
            }
            completion(result)
        })
        task.resume()
    }
}
