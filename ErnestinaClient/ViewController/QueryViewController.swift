//
//  QueryViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/14.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var queryDictionaryArray:Array<Dictionary<String,String>> = []
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var queryCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryCollectionView.layer.cornerRadius = 10.0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:QueryCustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "queryCell", for: indexPath as IndexPath) as! QueryCustomCell
        
        let passage = queryDictionaryArray[indexPath.row]["passage"]!
        cell.queryPassageTextView.text = passage
        cell.queryPassageTextView.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.queryPassageTextView.layer.borderWidth = 0.7
        cell.queryPassageTextView.layer.cornerRadius = 4.0;
        cell.queryPassageTextView.clipsToBounds = true;
        
        cell.queryLabel.text = "Result " + String(indexPath.row + 1)
        
        cell.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.layer.cornerRadius = 10.0;
        cell.layer.borderWidth = 0.7;
        cell.clipsToBounds = true
        
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queryDictionaryArray.count
    }
    
    @IBAction func returnToQueryViewController(segue: UIStoryboardSegue) {
        
    }
}
