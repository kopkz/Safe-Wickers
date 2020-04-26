//
//  BeachListTableViewCell.swift
//  Safe Wickers
//
//  Created by 匡正 on 20/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit
protocol LoveBeachDelagate {
    func loveUnloveBeach(beach: Beach)
}

class BeachListTableViewCell: UITableViewCell {

    @IBOutlet weak var loveUnloveButton: UIButton!
    @IBOutlet weak var riskImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var beachNameLabel: UILabel!
    @IBOutlet weak var beachImage: UIImageView!
    
    var delegate: LoveBeachDelagate?
    var beachItem: Beach!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loveUnloveButton.addTarget(self, action: #selector(loveUnloveButtonTaped), for: .touchUpInside)
        loveUnloveButton.tintColor = UIColor.lightGray
    }
    func setBeach(beach: Beach){
        beachItem = beach
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func loveUnloveButtonTaped(){
        delegate?.loveUnloveBeach(beach: beachItem)
    }

}
