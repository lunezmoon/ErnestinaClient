//
//  ReviewNotesMenuViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/08/09.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class ReviewNotesMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //配列lectureDataを設定
    var lectureData:Array<Dictionary<String,String>> = []
    
    @IBOutlet weak var reviewNotesMenuTableView: UITableView!
    let borderAlpha : CGFloat = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewNotesMenuTableView.layer.cornerRadius = 4.0;
        reviewNotesMenuTableView.clipsToBounds = true;
        reviewNotesMenuTableView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        reviewNotesMenuTableView.layer.borderWidth = 0.7
        
        updateData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectureData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "lectureDataCell", for: indexPath)
        
        //ボタンを生成
        let button = UIButton(type: UIButtonType.system)
        
        //ボタンのメソッドを設定
        button.addTarget(self, action: #selector(self.clickLectureDataButton(sender: )), for: .touchUpInside)
        
        //ボタンのラベルを設定
        button.setTitle(lectureData[indexPath.row]["filename"], for: UIControlState.normal)
        button.accessibilityIdentifier = lectureData[indexPath.row]["documentId"]
        
        //ボタンのサイズを設定
        button.sizeToFit()
        
        //ボタンの位置を設定
        button.center = CGPoint(x: (view.bounds.width / 2.0) , y: 44.0 / 2.0)
        
        //削除ボタンを生成
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
            self.performSegue(withIdentifier: "toReviewNotesViewSegue", sender: sender)
        }
    }
    
    @objc func clickDeleteButton(sender: UIButton) {
        
        let restDatabaseConnector = RestDatabaseConnector()
        _ = restDatabaseConnector.deleteDocument(userId: GlobalValues.userId, documentId: sender.accessibilityIdentifier!)
        
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviewNotesViewSegue" {
            if let viewController = segue.destination as? ReviewNotesViewController {
                let button = sender as! UIButton
                viewController.lectureDataName = (button.titleLabel?.text!)!
                viewController.lectureDataId = (button.accessibilityIdentifier)!
            }
        }
    }
    
    @IBAction func returnToReviewNotesMenuViewController(segue: UIStoryboardSegue) {
        
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
        self.reviewNotesMenuTableView.reloadData()
    }
}
