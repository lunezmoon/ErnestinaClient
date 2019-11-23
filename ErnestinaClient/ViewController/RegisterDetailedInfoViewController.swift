//
//  RegisterDetailedInfoViewController.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2018/12/15.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class RegisterDetailedInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var roleDropDownTableView: UITableView!
    @IBOutlet weak var expertiseDropDownTableView: UITableView!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surnameReadTextField: UITextField!
    @IBOutlet weak var firstNameReadTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var expertiseTextField: UITextField!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var registerButton: UIButton!
    
    var ActivityIndicator: UIActivityIndicatorView!
    var userId = ""
    var password = ""
    var profilePicture: Data? = nil
    
    let borderAlpha : CGFloat = 0.7
    let roleArray = ["講師", "受講生"]
    let expertiseArray = ["営業", "コンサルタント", "デザイナー", "データサイエンティスト", "ITスペシャリスト", "プロジェクト・マネージャー"
        ,"製品開発エンジニア", "コーポレット・スタッフ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 4.0;
        registerButton.clipsToBounds = true;
        
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        ActivityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        ActivityIndicator.center = self.view.center
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        // 色を設定
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        ActivityIndicator.layer.cornerRadius = 10.0;
        ActivityIndicator.clipsToBounds = true;
        ActivityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        //Viewに追加
        self.view.addSubview(ActivityIndicator)
        self.view.bringSubview(toFront:
        ActivityIndicator)
        
        surnameTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        surnameTextField.layer.borderWidth = 0.7
        surnameTextField.layer.cornerRadius = 4.0;
        surnameTextField.clipsToBounds = true;
        surnameTextField.attributedPlaceholder = NSAttributedString(string: "姓",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        firstNameTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        firstNameTextField.layer.borderWidth = 0.7
        firstNameTextField.layer.cornerRadius = 4.0;
        firstNameTextField.clipsToBounds = true;
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "名",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        surnameReadTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        surnameReadTextField.layer.borderWidth = 0.7
        surnameReadTextField.layer.cornerRadius = 4.0;
        surnameReadTextField.clipsToBounds = true;
        surnameReadTextField.attributedPlaceholder = NSAttributedString(string: "セイ",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        firstNameReadTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        firstNameReadTextField.layer.borderWidth = 0.7
        firstNameReadTextField.layer.cornerRadius = 4.0;
        firstNameReadTextField.clipsToBounds = true;
        firstNameReadTextField.attributedPlaceholder = NSAttributedString(string: "メイ",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        roleTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        roleTextField.layer.borderWidth = 0.7
        roleTextField.layer.cornerRadius = 4.0;
        roleTextField.clipsToBounds = true;
        roleTextField.attributedPlaceholder = NSAttributedString(string: "役割を選択",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        expertiseTextField.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        expertiseTextField.layer.borderWidth = 0.7
        expertiseTextField.layer.cornerRadius = 4.0;
        expertiseTextField.clipsToBounds = true;
        expertiseTextField.attributedPlaceholder = NSAttributedString(string: "職種を選択",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        introductionTextView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        introductionTextView.layer.borderWidth = 0.7
        introductionTextView.layer.cornerRadius = 4.0;
        introductionTextView.clipsToBounds = true;
        
        roleDropDownTableView.isHidden = true
        expertiseDropDownTableView.isHidden = true
    }
    @IBAction func clickRoleDropDown(_ sender: Any) {
        roleDropDownTableView.isHidden = false
    }
    
    @IBAction func clickExpertiseDropDown(_ sender: Any) {
        expertiseDropDownTableView.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if (tableView == roleDropDownTableView) {
            count = roleArray.count
        }
        
        if (tableView == expertiseDropDownTableView) {
            count = expertiseArray.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == self.roleDropDownTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let previewDetail = roleArray[indexPath.row]
            cell!.textLabel!.text = previewDetail
            
        }
        
        if tableView == self.expertiseDropDownTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            let previewDetail = expertiseArray[indexPath.row]
            cell!.textLabel!.text = previewDetail
            
        }
        
        cell!.textLabel?.textColor = UIColor.white
        cell!.layer.borderWidth = 0.5
        cell!.layer.borderColor = UIColor.black.cgColor
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
        cell!.selectedBackgroundView = backgroundView

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == roleDropDownTableView) {
            let selectedItem = roleArray[indexPath.row]
            roleTextField.text = selectedItem
            
            roleDropDownTableView.isHidden = true
        }
        
        if (tableView == expertiseDropDownTableView) {
            let selectedItem = expertiseArray[indexPath.row]
            expertiseTextField.text = selectedItem
            
            expertiseDropDownTableView.isHidden = true
        }
    }
    
    @IBAction func clickRegister(_ sender: Any) {
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.ActivityIndicator.startAnimating()
            }
        
            let parameters: [String:String] = ["userId": self.userId,
                                               "password": self.password,
                                               "surname": self.surnameTextField.text!,
                                               "firstName": self.firstNameTextField.text!,
                                               "surnameRead": self.surnameReadTextField.text!,
                                               "firstNameRead": self.firstNameReadTextField.text!,
                                               "role": self.roleTextField.text!,
                                               "expertise": self.expertiseTextField.text!,
                                               "introduction": self.introductionTextView.text!]
            
            let restDatabaseConnector = RestDatabaseConnector()
            _ = restDatabaseConnector.addUserInfo(parameters: parameters, data: self.profilePicture!)
        
            DispatchQueue.main.async {
                self.ActivityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "toRegisterCompletedViewSegue", sender: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegisterCompletedViewSegue" {
            if let viewController = segue.destination as? RegisterCompletedViewController {
                viewController.userId = userId
            }
        }
    }
    
    @IBAction func returnToRegisterDetailedInfoViewController(segue: UIStoryboardSegue) {
        
    }

    @IBAction func clickButton(_ sender: Any) {
        ActivityIndicator.startAnimating()
        //ActivityIndicator.stopAnimating()
    }
}
