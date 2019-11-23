//
//  SendDocumentMenuViewController.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2019/01/22.
//  Copyright © 2019年 test. All rights reserved.
//

import UIKit

class SendDocumentMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var lectureData:Array<Dictionary<String,String>> = []
    var sendUserId = ""
    var fromUserId = ""
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var sendDocumentMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromUserId = GlobalValues.userId
        
        sendDocumentMenuTableView.layer.cornerRadius = 4.0;
        sendDocumentMenuTableView.clipsToBounds = true;
        sendDocumentMenuTableView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        sendDocumentMenuTableView.layer.borderWidth = 0.7
        
        
        updateData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectureData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルの取得
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "lectureDataCell", for: indexPath)
        
        //ボタンを生成
        let button = UIButton(type: UIButtonType.system)
        
        //ボタンのメソッドを設定
        button.addTarget(self, action: #selector(self.clickLectureDataButton(sender: )), for: .touchUpInside)
        
        //ラベルを設定
        button.setTitle(lectureData[indexPath.row]["documentName"], for: UIControlState.normal)
        button.accessibilityIdentifier = lectureData[indexPath.row]["documentId"]
        
        //サイズを設定
        button.sizeToFit()
        
        //位置を設定
        button.center = CGPoint(x: (view.bounds.width / 2.0) , y: 44.0 / 2.0)
        
        //削除ボタンを設定
        let deleteButton = UIButton(type: UIButtonType.system)
        
        //削除ボタンのメソッドを設定
        deleteButton.addTarget(self, action: #selector(self.clickDeleteButton(sender: )), for: .touchUpInside)
        
        //削除ボタンのラベルを設定
        deleteButton.setTitle("✖️", for: UIControlState.normal)
        deleteButton.accessibilityIdentifier = lectureData[indexPath.row]["documentId"]
        
        //削除ボタンのサイズを設定
        deleteButton.sizeToFit()
        
        //削除ボタンの位置を設定
        deleteButton.center = CGPoint(x: (view.bounds.width / 1.2) , y: 44.0 / 2.0)
        
        if(cell.subviews.count == 2){
            cell.addSubview(button)
            cell.addSubview(deleteButton)
        }
        
        return cell
    }
    
    @objc func clickLectureDataButton(sender: UIButton) {
        let now = Date()
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let dateString = formatter.string(from: now)
        
        let restDatabaseConnector = RestDatabaseConnector()
        _ = restDatabaseConnector.addDocument(userId: sendUserId, documentId: sender.accessibilityIdentifier!, documentName: (sender.titleLabel?.text)!, timestamp: dateString)
        
        dispAlert()
    }
    
    @objc func clickDeleteButton(sender: UIButton) {
        
        let restDatabaseConnector = RestDatabaseConnector()
        _ = restDatabaseConnector.deleteDocument(userId: GlobalValues.userId, documentId: sender.accessibilityIdentifier!)
        
        updateData()
    }
    
    @IBAction func returnToReviewLectureMenuViewController(segue: UIStoryboardSegue) {
        
    }
    
    func updateData(){
        
        let restDatabaseConnector = RestDatabaseConnector()
        let results = restDatabaseConnector.getAllDocuments(userId: fromUserId)
        
        self.lectureData.removeAll()
        
        for i in 0..<results.count {
            var documentDataDictionary = [String:String]()
            documentDataDictionary["documentId"] = results[i]["document_id"]
            documentDataDictionary["documentName"] = results[i]["document_name"]
            
            self.lectureData.append(documentDataDictionary)
        }
        self.sendDocumentMenuTableView.reloadData()
    }
    
    func dispAlert() {
        let alert: UIAlertController = UIAlertController(title: "送信が完了", message: "講義データの送信が完了しました", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: false, completion: nil)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
