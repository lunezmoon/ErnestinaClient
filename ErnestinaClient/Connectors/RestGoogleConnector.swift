//
//  RestGoogleConnector.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2018/12/12.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation

class RestGoogleConnector {
 
    private var hostName = ""
    
    init () {
        if let url = Bundle.main.url(forResource:"Ernestina", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String : Any]
                
                hostName = swiftDictionary["HostNameForRestAPI"] as! String
            } catch {
                print(error)
            }
        }
    }
    
    func customSearch (search: String) -> [[String:Any]] {
        
        var results = [[String:Any]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["search": search]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/google/customSearch")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            condition.lock()
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : []) as? [[String:Any]]
            if let responseJSON = responseJSON as? [[String:Any]] {
                results = responseJSON
            }
            condition.signal()
            condition.unlock()
        }
        condition.lock()
        task.resume()
        condition.wait()
        condition.unlock()
        
        return results
    }
}
