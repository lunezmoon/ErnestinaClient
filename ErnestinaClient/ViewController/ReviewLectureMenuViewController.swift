//
//  ReviewLectureMenuViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/06/26.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class ReviewLectureMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lectureData:Array<Dictionary<String,String>> = []
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var reviewLectureMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Review Lecture用の録音した授業内容のTable Listのフォーマット設定
        reviewLectureMenuTableView.layer.cornerRadius = 4.0;
        reviewLectureMenuTableView.clipsToBounds = true;
        reviewLectureMenuTableView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        reviewLectureMenuTableView.layer.borderWidth = 0.7
        
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
        button.setTitle(lectureData[indexPath.row]["filename"], for: UIControlState.normal)
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
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toReviewLectureViewSegue", sender: sender)
        }
    }
    
    @objc func clickDeleteButton(sender: UIButton) {
        let restDatabaseConnector = RestDatabaseConnector()
        _ = restDatabaseConnector.deleteDocument(userId: GlobalValues.userId, documentId: sender.accessibilityIdentifier!)
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviewLectureViewSegue" {
            if let viewController = segue.destination as? ReviewLectureViewController {
                    let button = sender as! UIButton
                viewController.lectureDataId = (button.accessibilityIdentifier)!
            }
        }
    }
    
    @IBAction func returnToReviewLectureMenuViewController(segue: UIStoryboardSegue) {
        
    }

    func updateData(){
        
        let restDatabaseConnector = RestDatabaseConnector()
        let results = restDatabaseConnector.getAllDocuments(userId: GlobalValues.userId)
        
        self.lectureData.removeAll()
        
        for i in 0..<results.count {
            var documentDataDictionary = [String:String]()
            documentDataDictionary["filename"] = results[i]["document_name"]
            documentDataDictionary["documentId"] = results[i]["document_id"]
            
            self.lectureData.append(documentDataDictionary)
        }
        self.reviewLectureMenuTableView.reloadData()
    }
}
