//
//  MainViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/06/23.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var recordLectureButton: UIButton!
    
    @IBOutlet weak var reviewLectureButton: UIButton!
    
    @IBOutlet weak var testPreparationButton: UIButton!
    
    @IBOutlet weak var reviewNotesButton: UIButton!
    
    @IBOutlet weak var userListButton: UIButton!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var recordLectureView: UIView!
    
    @IBOutlet weak var reviewLectureView: UIView!
    
    @IBOutlet weak var testPreparationView: UIView!
    
    @IBOutlet weak var reviewNotesView: UIView!
    
    @IBOutlet weak var userListView: UIView!
    
    @IBOutlet weak var editProfileView: UIView!
    
    let borderAlpha : CGFloat = 0.7
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //メインメニューのアイコンの画像とフォーマットを設定
        recordLectureButton.setImage(UIImage(named: "RecordMenu_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        recordLectureButton.tintColor = UIColor.white
        
        reviewLectureButton.setImage(UIImage(named: "ReviewMenu_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reviewLectureButton.tintColor = UIColor.white
        
        testPreparationButton.setImage(UIImage(named: "TestPreparationMenu_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        testPreparationButton.tintColor = UIColor.white
        
        reviewNotesButton.setImage(UIImage(named: "SettingsMenu_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reviewNotesButton.tintColor = UIColor.white
        
        userListButton.setImage(UIImage(named: "User_List_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        userListButton.tintColor = UIColor.white
        
        editProfileButton.setImage(UIImage(named: "Edit_Profile_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        editProfileButton.tintColor = UIColor.white
        
        recordLectureView.layer.cornerRadius = 4.0;
        recordLectureView.clipsToBounds = true;
        recordLectureView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        recordLectureView.layer.borderWidth = 0.7
        recordLectureView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        reviewLectureView.layer.cornerRadius = 4.0;
        reviewLectureView.clipsToBounds = true;
        reviewLectureView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        reviewLectureView.layer.borderWidth = 0.7
        reviewLectureView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        testPreparationView.layer.cornerRadius = 4.0;
        testPreparationView.clipsToBounds = true;
        testPreparationView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        testPreparationView.layer.borderWidth = 0.7
        testPreparationView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        reviewNotesView.layer.cornerRadius = 4.0;
        reviewNotesView.clipsToBounds = true;
        reviewNotesView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        reviewNotesView.layer.borderWidth = 0.7
        reviewNotesView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        userListView.layer.cornerRadius = 4.0;
        userListView.clipsToBounds = true;
        userListView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        userListView.layer.borderWidth = 0.7
        userListView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        editProfileView.layer.cornerRadius = 4.0;
        editProfileView.clipsToBounds = true;
        editProfileView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        editProfileView.layer.borderWidth = 0.7
        editProfileView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickRecordLecture(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toRecordLectureViewSegue", sender: nil)
        }
    }
    
    @IBAction func clickReviewLecture(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toReviewLectureMenuViewSegue", sender: nil)
        }
    }
    
    @IBAction func clickTestPreparation(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toTestPreparationMenuViewSegue", sender: nil)
        }
    }
    
    @IBAction func clickReviewNotes(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toReviewNotesMenuViewSegue", sender: nil)
        }
    }
    @IBAction func clickUserListMenu(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toUserListViewSegue", sender: nil)
        }
    }
    
    @IBAction func returnToMainViewController(segue: UIStoryboardSegue) {
        
    }
}
