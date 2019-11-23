//
//  UserStatisticsCustomCell.swift
//  ErnestinaClient
//
//  Created by Hiroki Harigai on 2019/01/10.
//  Copyright © 2019年 test. All rights reserved.
//

import Foundation
import UIKit

class UserStatisticsCustomCell: UICollectionViewCell {

    @IBOutlet weak var questionNumberLabel: UILabel!
    
    @IBOutlet weak var markImage: UIImageView!
    
    @IBOutlet weak var passageTextView: UITextView!
    
    @IBOutlet weak var option1Label: UILabel!
    
    @IBOutlet weak var option2Label: UILabel!
    
    @IBOutlet weak var option3Label: UILabel!
    
    @IBOutlet weak var option4Label: UILabel!
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
}
