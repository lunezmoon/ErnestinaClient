//
//  EntityCustomCell.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/07.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation
import UIKit

class EntityCustomCell: UICollectionViewCell {
    
    
    @IBOutlet weak var entityImage: CustomImageView!
    
    @IBOutlet weak var entityLabel: UILabel!
    
    @IBOutlet weak var entityText: UITextView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}
