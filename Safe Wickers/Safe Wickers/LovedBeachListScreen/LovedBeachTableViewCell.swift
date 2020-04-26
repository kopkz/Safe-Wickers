//
//  LovedBeachTableViewCell.swift
//  Safe Wickers
//
//  Created by 匡正 on 26/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class LovedBeachTableViewCell: UITableViewCell {

    @IBOutlet weak var loveUnloveButton: UIButton!
    @IBOutlet weak var beachImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var riskImageView: UIImageView!
    @IBOutlet weak var beachNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
