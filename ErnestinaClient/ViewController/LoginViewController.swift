//
//  LoginViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/06/16.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var textFieldUserID = ""
    var textFieldPasword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 4.0;
        loginButton.clipsToBounds = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        
        if (userIDTextField.text! != "" && passwordTextField.text! != "") {
        
            textFieldUserID = userIDTextField.text!
            textFieldPasword = passwordTextField.text!
            
            let restDatabaseConnector = RestDatabaseConnector()
            let results = restDatabaseConnector.getUserInfo(userId: textFieldUserID)
            
            if (results.count == 0) {
                dispAlertWrongUserId()
            }
            else {
                let password = results[0]["password"]
                if (password == textFieldPasword) {
                    GlobalValues.userId = textFieldUserID
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toMainViewSegue", sender: nil)
                    }
                }
                else {
                    dispAlertWrongPassword()
                }
            }
        }
        else {
            dispAlertBlankInputFields()
        }
    }
    
    @IBAction func clickRegister(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toRegisterViewSegue", sender: nil)
        }
    }
    
    @IBAction func returnToLoginViewController(segue: UIStoryboardSegue) {
        
    }
    
    func dispAlertWrongPassword() {
        let alert: UIAlertController = UIAlertController(title: "パスワードが間違っています", message: "パスワードの再入力をお願いします", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: false, completion: nil)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func dispAlertWrongUserId() {
        let alert: UIAlertController = UIAlertController(title: "ユーザーIDが間違っています", message: "ユーザーIDの再入力をお願いします", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: false, completion: nil)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func dispAlertBlankInputFields() {
        let alert: UIAlertController = UIAlertController(title: "入力が不足しています", message: "ユーザーIDもしくはパスワードの入力をお願いします", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: false, completion: nil)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
