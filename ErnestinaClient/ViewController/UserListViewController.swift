//
//  UserListViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/10/10.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var userArray:NSArray? = nil
    var data:Data? = nil
    var userListDictionaryArray:Array<Dictionary<String,String>> = []
    var searchedArray: Array<Dictionary<String,String>> = []
    let borderAlpha : CGFloat = 0.7
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var userListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = GlobalValues.userId
        let restDatabaseConnector = RestDatabaseConnector()
        let results = restDatabaseConnector.getAllUserInfo()
        
        var userListDictionary = [String:String]()
        
        for i in 0..<results.count {

            if (userId != results[i]["user_id"]) {
                userListDictionary["userId"] = results[i]["user_id"]
                userListDictionary["name"] = results[i]["surname"]! + " " + results[i]["first_name"]!
                userListDictionary["nameRead"] = results[i]["surname_read"]! + " " + results[i]["first_name_read"]!
                userListDictionary["expertise"] = results[i]["expertise"]
                userListDictionary["introduction"] = results[i]["introduction"]
                userListDictionary["profilePicture"] = results[i]["profile_image_location"]
                self.userListDictionaryArray.append(userListDictionary)
                self.searchedArray = self.userListDictionaryArray
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UserCustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath as IndexPath) as! UserCustomCell
        
        let userListDictionary = searchedArray[indexPath.row]
        let user_id = userListDictionary["userId"]!
        let name = userListDictionary["name"]!
        let name_read = userListDictionary["nameRead"]!
        let expertise = userListDictionary["expertise"]!
        let introduction = userListDictionary["introduction"]!
        let profilePicture = userListDictionary["profilePicture"]
        
        /*
        let url = URL(string: profilePicture!)
        let imageData = try! Data(contentsOf: url!)
        let image = UIImage(data: imageData)
        */
        
        cell.nameLabel.text = name
        cell.nameReadLabel.text = name_read
        cell.expertiseLabel.text = expertise
        
        //cell.profileImg.image = image
        cell.profileImg.cacheImage(urlString: profilePicture!)
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width / 2
        cell.profileImg.clipsToBounds = true
        cell.profileImg.layer.borderWidth = 1.0
        cell.profileImg.layer.borderColor = UIColor.white.cgColor
        
        cell.introductionTextView.text = introduction
        cell.introductionTextView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.introductionTextView.layer.borderWidth = 0.7
        cell.introductionTextView.layer.cornerRadius = 4.0;
        cell.introductionTextView.clipsToBounds = true;
        
        cell.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.layer.cornerRadius = 10.0;
        cell.layer.borderWidth = 0.7;
        cell.clipsToBounds = true;
        
        cell.sendDataButton.setImage(UIImage(named: "Send_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.testResultsHistoryButton.setImage(UIImage(named: "TestResultHistory_Icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.sendDataButton.tintColor = UIColor.white
        cell.testResultsHistoryButton.tintColor = UIColor.white
       
        cell.testResultsHistoryButton.accessibilityIdentifier = user_id
        cell.testResultsHistoryButton.addTarget(self, action: #selector(self.clickStatisticsButton(sender: )), for: .touchUpInside)
        cell.sendDataButton.accessibilityIdentifier = user_id
        cell.sendDataButton.addTarget(self, action: #selector(self.clickSendDataButton(sender: )), for: .touchUpInside)
        
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedArray.count
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchItems(searchText: searchText)
    }
    
    //MARK: キャンセルボタンが押されると呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelled")
    }
    
    //MARK: Searchボタンが押されると呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searched")
    }
    
    func searchItems(searchText: String) {
        
        //要素を検索する
        if searchText != "" {
            searchedArray = userListDictionaryArray.filter { myItem in
                return (myItem["name"])!.contains(searchText)
                } as Array<Dictionary<String,String>>
        } else {
            //渡された文字列が空の場合は全てを表示
            searchedArray = userListDictionaryArray
        }
        
        //再読み込みする
        userListCollectionView.reloadData()
    }
    
    @objc func clickStatisticsButton(sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toUserStatisticsMenuViewSegue", sender: sender)
        }
    }
    
    @objc func clickSendDataButton(sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toSendDocumentMenuViewSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserStatisticsMenuViewSegue" {
            if let viewController = segue.destination as? UserStatisticsMenuViewController {
                let button = sender as! UIButton
                viewController.userId = button.accessibilityIdentifier!
            }
        } else if segue.identifier == "toSendDocumentMenuViewSegue" {
            if let viewController = segue.destination as? SendDocumentMenuViewController {
                let button = sender as! UIButton
                viewController.sendUserId = button.accessibilityIdentifier!
            }
        }
    }
    
    @IBAction func returnToUserListViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
