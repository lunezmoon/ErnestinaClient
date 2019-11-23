//
//  HttpService.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2018/11/28.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation

class HttpService {
    
    static func createMultipartBody(parameters: [String: String], boundary: String, data: Data, mimeType: String, filename: String) throws -> Data {
        
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
