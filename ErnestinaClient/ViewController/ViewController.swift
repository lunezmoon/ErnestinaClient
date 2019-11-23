//
//  ViewController.swift
//  Watson_Project
//
//  Created by 針谷ひろき on 2018/04/30.
//  Copyright © 2018年 test. All rights reserved.
//
// Ernestina mobile app


import UIKit
import AVFoundation
import SpeechToTextV1
import AssistantV1
import Starscream
import SimplePDF

class ViewController: UIViewController {
    
    var recorder:AVAudioRecorder!
    var response_message:String?
    var context: Context? // save context to continue conversation
    
    //Watson Speech to Text
    let speechToText = SpeechToText(username: "cc0e510f-1211-4333-9783-fd47d0460ca0", password: "I5RXzhX5uDrQ")
    var accumulator = SpeechRecognitionResultsAccumulator()
    
    //Watson Assistant
    let assistant = Assistant(username: "9202a9a1-7a7a-49c0-9158-2396134d957e", password: "ISFJSMjeShLB", version: "2018-05-05")
    let workspaceID = "9c7cd556-0827-4dce-8271-cb824dd25a81"
    
    @IBOutlet weak var transcribedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func go(_ sender: UIButton) {
        
        var input: InputData?
        
        //Prepare pdf
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)

        var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
        settings.interimResults = true
        settings.wordConfidence = true
        
        let failure = { (error: Error) in print(error) }
        speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
            self.accumulator.add(results: results)
                if results.results![0].alternatives[0].wordConfidence != nil {
                    print("start")
                    print(results)
                    print("end")
                    input = InputData(text: results.results![0].alternatives[0].transcript)
                    self.conversation(input: input!)
                    sleep(1) //TODO
                    self.transcribedLabel.text = self.response_message
        
                    pdf.addText(results.results![0].alternatives[0].transcript)
                    let pdfData = pdf.generatePDFdata()
                    let fileURL = NSURL.fileURL(withPath: "/Users/harigaihiroki/test.pdf");
                    print("passed1");
                    //let documentDirFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
                    //print(documentDirFileURL)
                    try? pdfData.write(to: fileURL, options: .atomic)
                    print("passed2");
                    
            }
        }
    }
    @IBAction func stop(_ sender: Any) {
        speechToText.stopRecognizeMicrophone()
    }
    
    func conversation(input: InputData){
        
        let failure = { (error: Error) in print(error) }
        let request = MessageRequest(input: input, context: self.context)
        assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
            response in
            self.context = response.context
            self.response_message = response.output.text[0]
        }
    }
}


