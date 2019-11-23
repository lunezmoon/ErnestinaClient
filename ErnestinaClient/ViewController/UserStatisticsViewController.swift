//
//  UserStatisticsViewController.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2019/01/10.
//  Copyright © 2019年 test. All rights reserved.
//

import UIKit

class UserStatisticsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var testId = ""
    var testResultsData = [[String:String]]()
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let restDatabaseController = RestDatabaseConnector()
        testResultsData = restDatabaseController.getTestResultsHistory(testId: testId)
        
        
        ratingLabel.text = testResultsData[0]["rating"]!
        scoreLabel.text = testResultsData[0]["score"]! + "/" + testResultsData[0]["total_score"]!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UserStatisticsCustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userStatisticsCell", for: indexPath as IndexPath) as! UserStatisticsCustomCell
        
        cell.questionNumberLabel.text! = "Question " + String(indexPath.row + 1)
        if (testResultsData[indexPath.row]["selected_ans"] == testResultsData[indexPath.row]["correct_ans"]) {
            cell.markImage.image = UIImage(named: "Correctmark_Icon")
        } else {
            cell.markImage.image = UIImage(named: "Incorrectmark_Icon")
        }
        cell.passageTextView.text! = testResultsData[indexPath.row]["passage"]!
        cell.passageTextView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.passageTextView.layer.borderWidth = 0.7
        cell.passageTextView.layer.cornerRadius = 4.0;
        cell.passageTextView.clipsToBounds = true;
        
        cell.option1Label.text = testResultsData[indexPath.row]["option_1"]
        let option1Color = checkOption(option: testResultsData[indexPath.row]["option_1"]!, selectedAns: testResultsData[indexPath.row]["selected_ans"]!, correctAns: testResultsData[indexPath.row]["correct_ans"]!)
        if (option1Color == "Green") {
            cell.option1Label.layer.borderColor = UIColor.green.cgColor
        } else if (option1Color == "Red") {
            cell.option1Label.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.option1Label.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        }
        cell.option1Label.layer.borderWidth = 0.7
        cell.option1Label.layer.cornerRadius = 4.0;
        cell.option1Label.clipsToBounds = true;
        
        cell.option2Label.text = testResultsData[indexPath.row]["option_2"]
        let option2Color = checkOption(option: testResultsData[indexPath.row]["option_2"]!, selectedAns: testResultsData[indexPath.row]["selected_ans"]!, correctAns: testResultsData[indexPath.row]["correct_ans"]!)
        if (option2Color == "Green") {
            cell.option2Label.layer.borderColor = UIColor.green.cgColor
        } else if (option2Color == "Red") {
            cell.option2Label.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.option2Label.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        }
        cell.option2Label.layer.borderWidth = 0.7
        cell.option2Label.layer.cornerRadius = 4.0;
        cell.option2Label.clipsToBounds = true;
        
        cell.option3Label.text = testResultsData[indexPath.row]["option_3"]
        let option3Color = checkOption(option: testResultsData[indexPath.row]["option_3"]!, selectedAns: testResultsData[indexPath.row]["selected_ans"]!, correctAns: testResultsData[indexPath.row]["correct_ans"]!)
        if (option3Color == "Green") {
            cell.option3Label.layer.borderColor = UIColor.green.cgColor
        } else if (option3Color == "Red") {
            cell.option3Label.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.option3Label.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        }
        cell.option3Label.layer.borderWidth = 0.7
        cell.option3Label.layer.cornerRadius = 4.0;
        cell.option3Label.clipsToBounds = true;
        
        cell.option4Label.text = testResultsData[indexPath.row]["option_4"]
        let option4Color = checkOption(option: testResultsData[indexPath.row]["option_4"]!, selectedAns: testResultsData[indexPath.row]["selected_ans"]!, correctAns: testResultsData[indexPath.row]["correct_ans"]!)
        if (option4Color == "Green") {
            cell.option4Label.layer.borderColor = UIColor.green.cgColor
        } else if (option4Color == "Red") {
            cell.option4Label.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.option4Label.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        }
        cell.option4Label.layer.borderWidth = 0.7
        cell.option4Label.layer.cornerRadius = 4.0;
        cell.option4Label.clipsToBounds = true;
        
        cell.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.layer.cornerRadius = 10.0;
        cell.layer.borderWidth = 0.7;
        cell.clipsToBounds = true;
        
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testResultsData.count
    }
    
    func checkOption(option: String, selectedAns: String, correctAns: String) -> String {
        
        if (option == correctAns) {
            return "Green"
        } else {
            if (option == selectedAns) {
                return "Red"
            } else {
                return "Clear"
            }
        }
    }
}
