//
//  FilterButtonTableViewCell.swift
//  Safe Wickers
//
//  Created by 匡正 on 25/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

protocol FilterCellDelegate{
    func sortingByInitials()
    func sortingByDistance()
    func onlyShowSafeBeach()
    func showAllBeach()
}

class FilterButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var onlySafeLabel: UILabel!
    @IBOutlet weak var onlySafeSwitch: UISwitch!
    
    var delegate: FilterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onlySafeSwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onlySafeSwitch(_ sender: UISwitch) {
        delegate?.onlyShowSafeBeach()
    }
    
    @IBAction func distanceSorting(_ sender: Any) {
        delegate?.sortingByDistance()
    }
    @IBAction func initialsSorting(_ sender: UIButton) {
        delegate?.sortingByInitials()
    }
    @objc func switchDidChange(){
        if onlySafeSwitch.isOn{
            delegate?.onlyShowSafeBeach()
        } else{
           delegate?.showAllBeach()
        }
    }
    
}
