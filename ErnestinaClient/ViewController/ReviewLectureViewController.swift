//
//  ReviewLectureViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/06/27.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit
import AVFoundation
import SpeechToTextV1
import AssistantV1
import DiscoveryV1
import Foundation
import SwiftyJSON
import MBCircularProgressBar
import SwiftGifOrigin
import AVFoundation
import Starscream

class ReviewLectureViewController: UIViewController {
    
    var lectureDataId:String = ""
    var urlArray:Array<URL> = []
    var imageSearchDictionaryArray:Array<Dictionary<String,Any>> = []
    var queryDictionaryArray:Array<Dictionary<String,String>> = []
    var recorder:AVAudioRecorder!
    var response_message:String?
    var context: Context? // save context to continue conversation
    var input: InputData?
    var ActivityIndicator: UIActivityIndicatorView!
    
    //Watson Speech to Text用のインスタンスを生成
    let speechToText = SpeechToText(username: GlobalValues.speechToTextUserId, password: GlobalValues.speechToTextPassword)
    var accumulator = SpeechRecognitionResultsAccumulator()

    @IBOutlet weak var queryButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var userTextView: UITextView!
    @IBOutlet weak var watsonTextView: UITextView!
    //@IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var queryEngineGif: UIImageView!
    @IBOutlet weak var queryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        ActivityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        ActivityIndicator.center = self.view.center
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        // 色を設定
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        ActivityIndicator.layer.cornerRadius = 10.0;
        ActivityIndicator.clipsToBounds = true;
        ActivityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        //Viewに追加
        self.view.addSubview(ActivityIndicator)
        self.view.bringSubview(toFront:
            ActivityIndicator)
        
        //Record Lecture Viewのボタンのフォーマット設定
        queryButton.layer.cornerRadius = 10.0;
        queryButton.clipsToBounds = true;
        
        //Review Lecture ViewのGif Imageのフォーマット設定
        queryEngineGif.image = UIImage.gif(name: "QueryEngine")
        queryEngineGif.layer.cornerRadius = queryEngineGif.frame.size.width / 2
        queryEngineGif.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickQueryButton(_ sender: Any) {
        
        let queryText = self.queryTextField.text!
        self.queryTextField.text = ""
        self.userTextView.text = queryText
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.ActivityIndicator.startAnimating()
            }
            
            let restWatsonAssistantConnector = RestWatsonAssistantConnector()
            let output = restWatsonAssistantConnector.message(input: queryText)
            
            DispatchQueue.main.async {
                self.watsonTextView.text = output["text"]
            }
            
            if (output["intent"] == "EntitySearch") {
                self.executeEntitySearch()
            }
            else if (output["intent"] == "その他") {
                self.executeQuerySearch(query: self.userTextView.text)
            }
            DispatchQueue.main.async {
                self.ActivityIndicator.stopAnimating()
            }
        }
    }
    
    func executeEntitySearch() {
        
        let restWatsonDiscoveryConnector = RestWatsonDiscoveryConnector()
        let restWatsonNlcConnector = RestWatsonNlcConnector();
        let restDbpediaConnector = RestDbpediaConnector();
        
        let results = restWatsonDiscoveryConnector.query(lectureDataId: lectureDataId, query: "")
        let text = results[0]["text"] as? String
        
        let nlcResults = restWatsonNlcConnector.analyze(text: text!)
        
        if (nlcResults.count != 0) {
            let conceptsArray = (nlcResults["concepts"] as? [Dictionary<String,Any>])!
            
            if (conceptsArray.count != 0) {
                for i in 0..<conceptsArray.count {
                    let concept = (conceptsArray[i]["text"] as? String)!
                    
                    let conceptInformation = restDbpediaConnector.getInformation(label: concept)
                    let conceptInformationResults = conceptInformation["results"] as? [String:Any]
                    let conceptInformationBindings = conceptInformationResults!["bindings"] as? [[String:Any]]
                    let conceptInformationComment = conceptInformationBindings![0]["comment"] as? [String:String]
                    let conceptInformationThumbnail = conceptInformationBindings![0]["thumbnail"] as? [String:String]
                    
                    var customSearchDataDictionary:Dictionary<String,Any> = [:]
                    customSearchDataDictionary["keyword"] = concept
                    if (conceptInformationThumbnail != nil) {
                        customSearchDataDictionary["imageURL"] = conceptInformationThumbnail!["value"]
                    } else {
                        customSearchDataDictionary["imageURL"] = "https://dubsism.files.wordpress.com/2017/12/image-not-found.png"
                    }
                    customSearchDataDictionary["description"] = conceptInformationComment!["value"]

                    imageSearchDictionaryArray.append(customSearchDataDictionary)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toEntityViewSegue", sender: nil)
        }
    }
    
    func executeQuerySearch(query: String) {
        
        let restWatsonDiscoveryConnector = RestWatsonDiscoveryConnector()
        let results = restWatsonDiscoveryConnector.naturalLanguageQuery(lectureDataId: lectureDataId, query: query)
        let passages = (results["passages"] as? [[String:Any]])!
        print(passages)
        
        for i in 0..<passages.count {
            var customSearchDataDictionary:Dictionary<String,String> = [:]
            customSearchDataDictionary["passage"] = passages[i]["passage_text"] as? String
            queryDictionaryArray.append(customSearchDataDictionary)
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toQueryViewSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntityViewSegue" {
            if let viewController = segue.destination as? EntityViewController {
                viewController.imageSearchDictionaryArray = imageSearchDictionaryArray
            }
        }
        else if segue.identifier == "toQueryViewSegue" {
            if let viewController = segue.destination as? QueryViewController {
                viewController.queryDictionaryArray = queryDictionaryArray
            }
        }
    }
    
    @IBAction func returnToReviewLectureViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


