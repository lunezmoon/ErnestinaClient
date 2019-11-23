//
//  UserStatisticsMenuViewController.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2019/01/10.
//  Copyright © 2019年 test. All rights reserved.
//

import UIKit

class UserStatisticsMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //配列lectureDataを設定
    var testResultsData = [[String:String]]()
    var userId = ""
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var testResultsHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testResultsHistoryTableView.layer.cornerRadius = 4.0;
        testResultsHistoryTableView.clipsToBounds = true;
        testResultsHistoryTableView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        testResultsHistoryTableView.layer.borderWidth = 0.7
        
        let restDatabaseConnector = RestDatabaseConnector()
        
        testResultsData = restDatabaseConnector.getAllTestResultsHistory(userId: userId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testResultsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "lectureDataCell", for: indexPath)
        
        //ボタンを生成
        let button = UIButton(type: UIButtonType.system)
        
        //ボタンのメソッドを設定
        button.addTarget(self, action: #selector(self.clickTestResultsDataButton(sender: )), for: .touchUpInside)
        
        //ボタンのラベルを設定
        button.setTitle(testResultsData[indexPath.row]["lecture_title"]! + "  " + testResultsData[indexPath.row]["timestamp"]!.replacingOccurrences(of: "Z", with: " ").replacingOccurrences(of: "T", with: " "), for: UIControlState.normal)
        button.accessibilityIdentifier = testResultsData[indexPath.row]["test_id"]
        
        //ボタンのサイズを設定
        button.sizeToFit()
        
        //ボタンの位置を設定
        button.center = CGPoint(x: (view.bounds.width / 2.0) , y: 44.0 / 2.0)
    
        if(cell.subviews.count == 2){
            cell.addSubview(button)
        }
        
        return cell
    }
    
    @objc func clickTestResultsDataButton(sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toUserStatisticsViewSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserStatisticsViewSegue" {
            if let viewController = segue.destination as?
                UserStatisticsViewController {
                let button = sender as! UIButton
                viewController.testId = (button.accessibilityIdentifier)!
            }
        }
    }
    
    @IBAction func returnToUserStatisticsMenuViewController(segue: UIStoryboardSegue) {
        
    }
}
