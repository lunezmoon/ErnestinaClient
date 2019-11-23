//
//  TestPreparationResultViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/30.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class TestPreparationResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var score: Int?
    var totalScore: Int?
    var testResultsArray: Array<Dictionary<String,String>> = []
    var lectureTitle = ""
    var rating = ""
    let restDatabaseConnector = RestDatabaseConnector()
    
    func showRating() {
        var color = UIColor.black
        guard let sc = score, let tc = totalScore else { return }
        let s = sc * 100 / tc
        if s < 10 {
            rating = "Poor"
            color = UIColor.white
        }  else if s < 40 {
            rating = "Average"
            color = UIColor.white
        } else if s < 60 {
            rating = "Good"
            color = UIColor.white
        } else if s < 80 {
            rating = "Excellent"
            color = UIColor.white
        } else if s <= 100 {
            rating = "Outstanding"
            color = UIColor.white
        }
        lblRating.text = "\(rating)"
        lblRating.textColor=color
    }
    
    @objc func btnRestartAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func btnFinishAction() {
        
        let uniqueId = restDatabaseConnector.getTestResultsHistoryUniqueId();
        
        let now = Date()
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let dateString = formatter.string(from: now)
   
        for i in 0..<testResultsArray.count {
            var parameters = [String:String]()
            parameters["testId"] = uniqueId[0]["nextval"]
            parameters["lectureTitle"] = lectureTitle
            parameters["score"] = String(describing: score!)
            parameters["totalScore"] = String(describing: totalScore!)
            parameters["rating"] = rating
            parameters["timestamp"] = dateString
            parameters["userId"] = GlobalValues.userId
            parameters["option1"] = testResultsArray[i]["option1"]
            parameters["option2"] = testResultsArray[i]["option2"]
            parameters["option3"] = testResultsArray[i]["option3"]
            parameters["option4"] = testResultsArray[i]["option4"]
            parameters["passage"] = testResultsArray[i]["passage"]
            parameters["correctAns"] = testResultsArray[i]["correctAns"]
            parameters["selectedAns"] = testResultsArray[i]["selectedAns"]
            print(parameters)
            _ = restDatabaseConnector.addTestResults(parameters: parameters)
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toMainViewSegue", sender: nil)
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive=true
        lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblTitle.widthAnchor.constraint(equalToConstant: 250).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 80).isActive=true
        
        self.view.addSubview(lblScore)
        lblScore.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 0).isActive=true
        lblScore.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblScore.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblScore.heightAnchor.constraint(equalToConstant: 60).isActive=true
        lblScore.text = "\(score!) / \(totalScore!)"
        
        self.view.addSubview(lblRating)
        lblRating.topAnchor.constraint(equalTo: lblScore.bottomAnchor, constant: 40).isActive=true
        lblRating.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblRating.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblRating.heightAnchor.constraint(equalToConstant: 60).isActive=true
        showRating()
        
        self.view.addSubview(btnRestart)
        btnRestart.topAnchor.constraint(equalTo: lblRating.bottomAnchor, constant: 40).isActive=true
        btnRestart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        btnRestart.widthAnchor.constraint(equalToConstant: 150).isActive=true
        btnRestart.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnRestart.addTarget(self, action: #selector(btnRestartAction), for: .touchUpInside)
        
        self.view.addSubview(btnFinish)
        btnFinish.topAnchor.constraint(equalTo: btnRestart.bottomAnchor, constant: 40).isActive=true
        btnFinish.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        btnFinish.widthAnchor.constraint(equalToConstant: 150).isActive=true
        btnFinish.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnFinish.addTarget(self, action: #selector(btnFinishAction), for: .touchUpInside)
    }
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text="Your Score"
        lbl.textColor=UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 46)
        lbl.numberOfLines=2
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblScore: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblRating: UILabel = {
        let lbl=UILabel()
        lbl.text="Good"
        lbl.textColor=UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRestart: UIButton = {
        let btn = UIButton()
        btn.setTitle("Restart", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange.withAlphaComponent(0.7)
        btn.layer.cornerRadius=5
        btn.clipsToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnFinish: UIButton = {
        let btn = UIButton()
        btn.setTitle("Finish", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.blue.withAlphaComponent(0.7)
        btn.layer.cornerRadius=5
        btn.clipsToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()

}
