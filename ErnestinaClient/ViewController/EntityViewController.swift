//
//  EntityViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/07.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit

class EntityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var urlArray:Array<URL> = []
    var imageSearchDictionaryArray:Array<Dictionary<String,Any>> = []
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var entityCollectionView: UICollectionView!
    
    override func viewDidLoad() {
       
       entityCollectionView.layer.cornerRadius = 10.0;
       super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:EntityCustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "entityCell", for: indexPath as IndexPath) as! EntityCustomCell
        
        /*
        let url = URL(string: imageSearchDictionaryArray[indexPath.row]["imageURL"]! as! String)
        let imageData = try! Data(contentsOf: url!)
        */
            
        cell.entityLabel.text = ((imageSearchDictionaryArray[indexPath.row]["keyword"]!) as! String)
        cell.entityText.text = ((imageSearchDictionaryArray[indexPath.row]["description"]!) as! String)
        
        cell.entityText.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.entityText.layer.borderWidth = 0.7
        cell.entityText.layer.cornerRadius = 4.0;
        cell.entityText.clipsToBounds = true;
        
        //cell.entityImage.image = UIImage(data: imageData)
        cell.entityImage.cacheImage(urlString: imageSearchDictionaryArray[indexPath.row]["imageURL"]! as! String)
        cell.entityImage.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        cell.entityImage.layer.borderWidth = 0.7
        cell.entityImage.layer.cornerRadius = 4.0;
        cell.entityImage.clipsToBounds = true;
        
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
        return imageSearchDictionaryArray.count
    }
    
    @IBAction func returnToEntityViewController(segue: UIStoryboardSegue) {
        
    }

}
