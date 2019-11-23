//
//  RegisterCompletedViewController.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2018/12/16.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class RegisterCompletedViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius = 4.0;
        startButton.clipsToBounds = true;
        
        let restDatabaseConnector = RestDatabaseConnector()
        let results = restDatabaseConnector.getUserInfo(userId: userId)
        let surname = results[0]["surname"]!
        let firstName = results[0]["first_name"]!
        let profileImg = results[0]["profile_image_location"]
        
        let url = URL(string: profileImg!)
        let imageData = try! Data(contentsOf: url!)
        let image = UIImage(data: imageData)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.image = image
        
        welcomeMessageLabel.text = surname + " " + firstName + "さん、"
        
    }
    
    @IBAction func clickBegin(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toMainViewSegue", sender: nil)
        }
    }
}
