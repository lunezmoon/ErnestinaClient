//
//  ReviewNotesViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/08/09.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class ReviewNotesViewController: UIViewController {
    
    var lectureDataName:String = ""
    var lectureDataId:String = ""
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var lectureNameLabel: UILabel!
    
    @IBOutlet weak var lectureTextView: UITextView!
    @IBOutlet weak var lectureTextBackgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ToDo
        lectureTextView.clipsToBounds = true;
        lectureTextView.layer.cornerRadius = 10.0;
        lectureTextView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        lectureTextView.layer.borderWidth = 0.7
        
        lectureTextBackgroundView.clipsToBounds = true;
        lectureTextBackgroundView.layer.cornerRadius = 10.0;
        
        lectureNameLabel.text = lectureDataName
        
        let restWatsonDiscoveryConnector = RestWatsonDiscoveryConnector()
        let results = restWatsonDiscoveryConnector.query(lectureDataId: lectureDataId, query: "")
        
        self.lectureTextView.text = results[0]["text"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
