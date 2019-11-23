//
//  QueryCustomCell.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/14.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation
import UIKit

class QueryCustomCell: UICollectionViewCell {
    
    @IBOutlet weak var queryPassageTextView: UITextView!
    
    @IBOutlet weak var queryLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}
