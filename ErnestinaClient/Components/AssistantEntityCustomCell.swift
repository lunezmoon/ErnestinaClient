//
//  AssistantEntityCustomCell.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/16.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation
import UIKit

class AssistantEntityCustomCell: UICollectionViewCell {
    
    @IBOutlet weak var assistantEntityImageView: UIImageView!
    
    @IBOutlet weak var assistantEntityTextView: UITextView!
    
    @IBOutlet weak var assistantEntityLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}
