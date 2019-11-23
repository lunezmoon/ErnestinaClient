//
//  RecordLectureViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/06/24.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit
import AVFoundation
import SpeechToTextV1
import AssistantV1
import Starscream
import SimplePDF
import SwiftyJSON

class RecordLectureViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var fileNameSettingChildView: UIView!
    
    @IBOutlet weak var fileNameTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var keywordLabel: UILabel!
    
    @IBOutlet weak var keywordImageView: UIImageView!
    
    @IBOutlet weak var keywordInfoTextView: UITextView!
    @IBOutlet weak var recordStyleSegmentedControl: UISegmentedControl!
    
    var timer = Timer()
    var recorder:AVAudioRecorder!
    var response_message:String?
    var context: Context?
    var assistantSearchDictionaryArray:Array<Dictionary<String,Any>> = []
    var entityDuplicationArray:Array<String> = []
    var randomNum = 0
    var text = ""
    var groupTranscriptFlag = false;
    var speakerLabelDictionaryArray:Array<Dictionary<String,String>> = []
    
    //Watson Speech to Text用のインスタンス生成
    let speechToText = SpeechToText(username: GlobalValues.speechToTextUserId, password: GlobalValues.speechToTextPassword)
    var accumulator = SpeechRecognitionResultsAccumulator()
    
    //Watson Discovery用のインスタンス生成
    var discoveryStartFlag = false
    var documentId = ""
    
    var pdfData:Data? = nil
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    var documentsDirectory = ""
    
    let restWatsonDiscoveryConnector = RestWatsonDiscoveryConnector()
    let restDatabaseConnector = RestDatabaseConnector()
    let restWatsonNlcConnector = RestWatsonNlcConnector()
    let restGoogleConnector = RestGoogleConnector()
    let restDbpediaConnector = RestDbpediaConnector()
    
    let borderAlpha : CGFloat = 0.7
    
    var finalResults:[SpeechRecognitionResult]? = nil
    var finalTranscriptWithLabel = ""
    var latestSpeaker = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsDirectory = paths[0] as String
        //Record Lecture Viewのボタンのフォーマット設定
        recordButton.layer.cornerRadius = 10.0;
        recordButton.clipsToBounds = true;
        
        stopButton.layer.cornerRadius = 10.0;
        stopButton.clipsToBounds = true;
        
        confirmButton.layer.cornerRadius = 10.0;
        confirmButton.clipsToBounds = true;
        
        self.view.bringSubview(toFront: fileNameSettingChildView)
        fileNameSettingChildView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        fileNameSettingChildView.layer.borderWidth = 0.7
        fileNameSettingChildView.layer.cornerRadius = 4.0;
        fileNameSettingChildView.clipsToBounds = true;
        fileNameSettingChildView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        keywordImageView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        keywordImageView.layer.borderWidth = 0.7
        keywordImageView.layer.cornerRadius = 4.0;
        keywordImageView.clipsToBounds = true;
        
        keywordInfoTextView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        keywordInfoTextView.layer.borderWidth = 0.7
        keywordInfoTextView.layer.cornerRadius = 4.0;
        keywordInfoTextView.clipsToBounds = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickRecord(_ sender: Any) {
        fileNameSettingChildView.isHidden = false;
    }
    
    @IBAction func clickStop(_ sender: Any) {
        recordButton.isHidden = false
        stopButton.isHidden = true
        timer.invalidate()
        
        //Speaker Label Logic Start
        print(self.finalTranscriptWithLabel.split(separator: "\n"))
        //Speaker Label Logic End
        
        /*
        //Prepare pdf Start
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        
        if (groupTranscriptFlag) {
            pdf.addText(self.finalTranscriptWithLabel)
        } else {
            pdf.addText(self.text)
        }
        self.pdfData = pdf.generatePDFdata()
        let fileURL = NSURL.fileURL(withPath: self.documentsDirectory + self.fileNameTextField.text! + ".pdf");
        try? self.pdfData?.write(to: fileURL, options: .atomic)
        //Prepare pdf End
        

        //Upload to Discovery Start
        let fileName = self.fileNameTextField.text! + ".pdf"
        let url = NSURL.fileURL(withPath: self.documentsDirectory + fileName)
        let data = NSData(contentsOfFile: url.path)! as Data
        
        let discoveryResults = restWatsonDiscoveryConnector.addDocument(data: data, fileName: fileName)
        documentId = discoveryResults["document_id"] as! String
        //Uplaod to Discovery End
        

        //Upload Document Id to Database Start
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateString = formatter.string(from: now)
        
        let databaseResults = restDatabaseConnector.addDocument(userId: GlobalValues.userId, documentId: documentId, documentName: fileName, timestamp: dateString)
        //Upload Document Id to Database End
        
        
        //Clean Directory Start
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: self.documentsDirectory + self.fileNameTextField.text!) {
            // Delete file
            try? fileManager.removeItem(atPath: self.documentsDirectory + self.fileNameTextField.text!)
        } else {
            print("File does not exist")
        }
        //Clean Directory End
        */
 
        speechToText.stopRecognizeMicrophone()
    }
 
    @IBAction func clickConfirm(_ sender: Any) {
        
        switch (recordStyleSegmentedControl.selectedSegmentIndex) {
        case 0:
            groupTranscriptFlag = true;
            normalTranscriptRecord()
            break;
            
        case 1:
            groupTranscriptFlag = false;
            groupWorkTranscriptRecord()
            break;
            
        default:
            break;
        }
    }
    
    func normalTranscriptRecord(){
        //timer処理
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
            self.showCell()
        })
        
        fileNameSettingChildView.isHidden = true;
        recordButton.isHidden = true
        stopButton.isHidden = false
        
        var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
        settings.interimResults = true
        settings.wordConfidence = true
        settings.speakerLabels = true
        settings.smartFormatting = true
        
        let failure = { (error: Error) in print(error) }
        speechToText.recognizeMicrophone(settings: settings, model: "ja-JP_BroadbandModel", failure: failure) { results in
            self.accumulator.add(results: results)
            print("start prep transcript")
            print(results)
            print("end prep transcript")
            if (results.results != nil && results.results![0].alternatives[0].wordConfidence != nil && results.results![0].finalResults == true) {
                print("Recorded sentence Start")
                print("start transcript")
                print(results)
                print("end transcript")
                sleep(1) //TODO
                
                //PDFに書き込み
                let trimmedString = results.results![0].alternatives[0].transcript.replacingOccurrences(of: " ", with: "")
                self.text = self.text + trimmedString
                
                self.addRandomCell()
                print("Recorded sentence end")
            }
        }
    }
    
    func groupWorkTranscriptRecord() {
        //timer処理
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
            self.showCell()
        })
        
        fileNameSettingChildView.isHidden = true;
        recordButton.isHidden = true
        stopButton.isHidden = false
        
        var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
        settings.interimResults = true
        settings.wordConfidence = true
        settings.speakerLabels = true
        settings.smartFormatting = true
        
        let failure = { (error: Error) in print(error) }
        speechToText.recognizeMicrophone(settings: settings, model: "ja-JP_BroadbandModel", failure: failure) { results in
            self.accumulator.add(results: results)
            
            if (results.speakerLabels != nil) {
                for i in 0..<results.speakerLabels!.count {
                    let speakerLabels = results.speakerLabels![i]
                    let speakerLabel = speakerLabels.speaker
                    let startTime = speakerLabels.from
                    let endTime = speakerLabels.to
                    for j in 0..<self.finalResults![0].alternatives[0].timestamps!.count {
                        let wordTimestamp = self.finalResults![0].alternatives[0].timestamps![j]
                        if (startTime == wordTimestamp.startTime && endTime == wordTimestamp.endTime) {
                            if (self.latestSpeaker == speakerLabel) {
                                self.finalTranscriptWithLabel = self.finalTranscriptWithLabel + wordTimestamp.word
                            }
                            else {
                                self.finalTranscriptWithLabel = self.finalTranscriptWithLabel + "\n" + String(speakerLabel) + ":" + wordTimestamp.word
                            }
                            self.latestSpeaker = speakerLabel
                        }
                    }
                }
            }
            
            print("start prep transcript")
            print(results)
            print("end prep transcript")
            if (results.results != nil && results.results![0].alternatives[0].wordConfidence != nil && results.results![0].finalResults == true) {
                print("Recorded sentence Start")
                print("start transcript")
                print(results)
                print("end transcript")
                sleep(1) //TODO
                
                //PDFに書き込み
                let trimmedString = results.results![0].alternatives[0].transcript.replacingOccurrences(of: " ", with: "")
                self.text = self.text + trimmedString
                
                self.finalResults = results.results
                
                self.addRandomCell()
                print("Recorded sentence end")
            }
        }
    }
    
    func addRandomCell() {
        
        let results = restWatsonNlcConnector.analyze(text: self.text)
        
        if (results.count != 0) {
            let conceptsArray = (results["concepts"] as? [Dictionary<String,Any>])!
            
            if (conceptsArray.count != 0) {
                for i in 0..<conceptsArray.count {
                    let concept = (conceptsArray[i]["text"] as? String)!
                    if (entityDuplicationArray.contains(concept) == false) {
                        var customSearchDataDictionary:Dictionary<String,String> = [:]
                        
                        let conceptInformation = restDbpediaConnector.getInformation(label: concept)
                        let conceptInformationResults = conceptInformation["results"] as? [String:Any]
                        let conceptInformationBindings = conceptInformationResults!["bindings"] as? [[String:Any]]
                        if (conceptInformationBindings![0]["comment"] != nil) {
                            let conceptInformationComment = conceptInformationBindings![0]["comment"] as? [String:String]
                            customSearchDataDictionary["description"] = conceptInformationComment!["value"]
                        } else {
                            customSearchDataDictionary["description"] = "No Comment"
                        }
                        let conceptInformationThumbnail = conceptInformationBindings![0]["thumbnail"] as? [String:String]
                        customSearchDataDictionary["keyword"] = concept
                        if (conceptInformationThumbnail != nil) {
                            customSearchDataDictionary["imageURL"] = conceptInformationThumbnail!["value"]
                        } else {
                            customSearchDataDictionary["imageURL"] = "https://dubsism.files.wordpress.com/2017/12/image-not-found.png"
                        }
                        
                        entityDuplicationArray.append(concept)
                        
                        assistantSearchDictionaryArray.append(customSearchDataDictionary)
                    }
                }
            }
        }
    }
    
    func showCell () {
        print("Cell Numbers: " + String(assistantSearchDictionaryArray.count))
        
        if (assistantSearchDictionaryArray.count > 0) {
            randomNum = Int(arc4random_uniform(UInt32(assistantSearchDictionaryArray.count - 1)))
            _ = assistantSearchDictionaryArray[randomNum]["keyword"] as? String
            
            keywordLabel.text = assistantSearchDictionaryArray[randomNum]["keyword"] as? String
            
            if (assistantSearchDictionaryArray[randomNum]["imageURL"]! as! String != "") {
                let url = URL(string: assistantSearchDictionaryArray[randomNum]["imageURL"]! as! String)
                let imageData = try! Data(contentsOf: url!)
                keywordImageView.image = UIImage(data: imageData)
            }
            
            if (assistantSearchDictionaryArray[randomNum]["description"] as! String != "") {
                keywordInfoTextView.text = (assistantSearchDictionaryArray[randomNum]["description"] as! String)
            }
        }
    }
    
    @IBAction func closeFileNameSettingChildView(_ sender: Any) {
        fileNameSettingChildView.isHidden = true
    }
    @IBAction func returnToRecordLectureViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
