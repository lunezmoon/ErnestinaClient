//
//  RestWatsonDiscoveryConnector.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2018/12/12.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation

class RestWatsonDiscoveryConnector {

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
    
    func query (lectureDataId: String, query: String) -> [[String:Any]] {
    
        var results = [[String:Any]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["documentId": lectureDataId, "query": query]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/watsonDiscovery/query")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : []) as? [[String: Any]]
            if let responseJSON = responseJSON as? [[String: Any]] {
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
    
    func naturalLanguageQuery (lectureDataId: String, query: String) -> [String:Any] {
        
        var results = [String:Any]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String:Any] = ["documentId": lectureDataId, "natural_language_query": query]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/watsonDiscovery/naturalLanguageQuery")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : []) as? [String: Any]
            if let responseJSON = responseJSON as? [String: Any] {
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
    
    func getAllDocumentInfo () -> [[String:Any]] {
        
        var results = [[String:Any]]()
        
        let condition = NSCondition()
        
        // create post request
        let url = URL(string: hostName + "/watsonDiscovery/getAllDocumentInfo")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            condition.lock()
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : []) as? [[String: Any]]
            if let responseJSON = responseJSON as? [[String: Any]] {
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
    
    func addDocument (data: Data, fileName: String) -> [String:Any]  {
        
        var results = [String:Any]()
        
        let condition = NSCondition()
        
        // create post request
        let url = URL(string: hostName + "/watsonDiscovery/addDocument")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["fileName": fileName]
        
        do {
            let multipartBody = try HttpService.createMultipartBody(parameters: parameters, boundary: boundary, data: data, mimeType: "application/pdf", filename: fileName)
            
            request.httpBody = multipartBody
        } catch let error {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            condition.lock()
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            if let responseJSON = responseJSON as? [String:Any] {
                results = responseJSON
                print("Retrieved Add Document Response Before")
                print(responseJSON);
                print("Retrieved Add Document Response After")
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
    
    func updateDocument (data: Data, documentId: String, fileName: String) -> [String:Any] {
        
        var results = [String:Any]()
        
        let condition = NSCondition()
        
        // create post request
        let url = URL(string: hostName + "/watsonDiscovery/updateDocument")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["documentId": documentId, "fileName": fileName]
        
        do {
            let multipartBody = try HttpService.createMultipartBody(parameters: parameters, boundary: boundary, data: data, mimeType: "application/pdf", filename: fileName)
            
            request.httpBody = multipartBody
        } catch let error {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            condition.lock()
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            if let responseJSON = responseJSON as? [String:Any] {
                results = responseJSON
                print("Retrieved Add Document Response Before")
                print(responseJSON);
                print("Retrieved Add Document Response After")
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
    
    func deleteDocument (documentId: String) -> [String:Any] {
        
        var results = [String:Any]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["documentId": documentId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/watsonDiscovery/deleteDocument")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : []) as? [String:Any]
            if let responseJSON = responseJSON as? [String:Any] {
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
