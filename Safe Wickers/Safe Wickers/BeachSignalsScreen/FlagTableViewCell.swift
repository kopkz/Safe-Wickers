//
//  FlagTableViewCell.swift
//  Safe Wickers
//
//  Created by 匡正 on 8/5/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class FlagTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var flagNameLabel: UILabel!
    
    @IBOutlet weak var meaningLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
