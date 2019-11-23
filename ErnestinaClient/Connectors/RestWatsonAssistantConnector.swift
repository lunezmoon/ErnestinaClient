//
//  RestWatsonAssistantConnector.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2018/12/12.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation

class RestWatsonAssistantConnector {

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
    
    func message (input: String) -> [String:String] {
        
        var results = [String:String]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["input": input]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/watsonAssistant/message")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                
                let output = responseJSON["output"] as? [String: Any]
                let texts = output?["text"] as! NSArray
                let intentArray = responseJSON["intents"] as! NSArray
                if (intentArray.count == 0) {
                    results["intent"] = "その他"
                } else {
                    let intents = intentArray[0] as? [String: Any]
                    results["intent"] = intents?["intent"] as? String
                }
                results["text"] = texts[0] as? String
                
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
