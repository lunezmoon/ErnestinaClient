//
//  UserCustomCell.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/10/10.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation
import UIKit

class UserCustomCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImg: CustomImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameReadLabel: UILabel!
    
    @IBOutlet weak var expertiseLabel: UILabel!
    
    @IBOutlet weak var introductionTextView: UITextView!
    
    @IBOutlet weak var sendDataButton: UIButton!
    
    @IBOutlet weak var testResultsHistoryButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}
