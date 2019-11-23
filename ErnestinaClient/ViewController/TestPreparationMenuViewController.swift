//
//  TestPreparationMenuViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/23.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class TestPreparationMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //配列lectureDataを設定
    var lectureData:Array<Dictionary<String,String>> = []
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var testPreparationMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testPreparationMenuTableView.layer.cornerRadius = 4.0;
        testPreparationMenuTableView.clipsToBounds = true;
        testPreparationMenuTableView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        testPreparationMenuTableView.layer.borderWidth = 0.7
        
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
        
        //削除ボタンの生成
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
        print("invoked " + (sender.titleLabel?.text!)!);
        let restWatsonDiscoveryConnector = RestWatsonDiscoveryConnector()
        let queryResults = restWatsonDiscoveryConnector.query(lectureDataId: sender.accessibilityIdentifier!, query: "")
        
        let enrichedText = queryResults[0]["enriched_text"] as? [String:Any]
        let concepts = enrichedText?["concepts"] as? [[String:Any]]
        
        if (concepts!.count < 4) {
            dispAlert()
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toTestPreparationViewSegue", sender: sender)
            }
        }
    }
    
    @objc func clickDeleteButton(sender: UIButton) {
        
        let restDatabaseConnector = RestDatabaseConnector()
        _ = restDatabaseConnector.deleteDocument(userId: GlobalValues.userId, documentId: sender.accessibilityIdentifier!)
        
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTestPreparationViewSegue" {
            if let viewController = segue.destination as? TestPreparationViewController {
                let button = sender as! UIButton
                viewController.lectureDataId = (button.accessibilityIdentifier)!
                viewController.lectureTitle = (button.titleLabel?.text!)!
            }
        }
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
        self.testPreparationMenuTableView.reloadData()
    }
    
    func dispAlert() {
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "データが足りません", message: "小テストを生成するには4つ以上のキーワードが必要です", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: false, completion: nil)
        })
        
        // ③ UIAlertControllerにActionを追加
        //alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
}
