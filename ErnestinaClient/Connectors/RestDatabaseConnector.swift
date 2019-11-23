//
//  RestApiDatabaseConnector.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2018/12/12.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation

class RestDatabaseConnector {
    
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
    
    func addUserInfo (parameters: [String:String], data: Data) -> [String:Any]{
        
        var results = [String:Any]()
        
        let condition = NSCondition()
        
        // create post request
        let url = URL(string: hostName + "/database/addUserInfo")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        do {
            let multipartBody = try HttpService.createMultipartBody(parameters: parameters, boundary: boundary, data: data, mimeType: "image/jpg", filename: "profilepicture.jpg")
            
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
                print(responseJSON);
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
    
    func addTestResults (parameters: [String:String]) -> [[String:String]]{
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["testId": parameters["testId"]!,
                                   "userId": parameters["userId"]!,
                                   "lectureTitle": parameters["lectureTitle"]!,
                                   "passage": parameters["passage"]!,
                                   "option1": parameters["option1"]!,
                                   "option2": parameters["option2"]!,
                                   "option3": parameters["option3"]!,
                                   "option4": parameters["option4"]!,
                                   "correctAns": parameters["correctAns"]!,
                                   "selectedAns": parameters["selectedAns"]!,
                                   "score": parameters["score"]!,
                                   "totalScore": parameters["totalScore"]!,
                                   "rating": parameters["rating"]!,
                                   "timestamp": parameters["timestamp"]!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/addTestResults")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
    
    func getUserInfo (userId: String) -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["userId": userId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/getUserInfo")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
    
    func getAllUserInfo () -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
    
        // create post request
        let url = URL(string: hostName + "/database/getAllUserInfo")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            condition.lock()
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            //var stringData = String(data: data, encoding: .utf8)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
                print(responseJSON);
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
    
    func getTestResultsHistoryUniqueId () -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // create post request
        let url = URL(string: hostName + "/database/getTestResultsHistoryUniqueId")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            condition.lock()
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            //var stringData = String(data: data, encoding: .utf8)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options : []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
                print(responseJSON);
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
    
    func getTestResultsHistory (testId: String) -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["testId": testId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/getTestResultsHistory")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
    
    func getAllTestResultsHistory (userId: String) -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["userId": userId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/getAllTestResultsHistory")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
    
    func addDocument (userId: String, documentId: String, documentName: String, timestamp: String) -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["userId": userId, "documentId": documentId, "documentName": documentName, "timestamp": timestamp]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/addDocument")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
    
    func getAllDocuments (userId: String) -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["userId": userId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/getAllDocuments")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
    
    func deleteDocument (userId: String, documentId: String) -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["userId": userId, "documentId": documentId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/deleteDocument")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
    
    func getproperty (propertyName: String) -> [[String:String]] {
        
        var results = [[String:String]]()
        
        let condition = NSCondition()
        
        // prepare json data
        let json: [String: Any] = ["propertyName": propertyName]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: hostName + "/database/getProperty")!
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            if let responseJSON = responseJSON as? [[String:String]] {
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
