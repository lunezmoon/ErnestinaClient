//
//  UIImageViewExtension.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2019/01/27.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    func cacheImage(urlString: String){
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = CustomImageView.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    CustomImageView.imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
            }.resume()
    }
}
