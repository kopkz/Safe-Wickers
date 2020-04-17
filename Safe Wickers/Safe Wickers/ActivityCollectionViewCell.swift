//
//  ActivityCollectionViewCell.swift
//  Safe Wickers
//
//  Created by 匡正 on 17/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    
    /// selected activity will have gray background, otherwise is white background
    override var isSelected: Bool{
        didSet(newValue){
            contentView.backgroundColor = newValue ? UIColor.gray : UIColor.white
        }
    }
}
