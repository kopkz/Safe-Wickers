//
//  SettingTableViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 15/5/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let SECTION_SETTING = 0
    let SECTION_HELP = 1
    
    let CELL_SETTING = "systemSettingCell"
    let CELL_HELP = "helpCell"
    
    var pickerView = UIPickerView()
    var pickValue = String()
    var pickChoices : [String] = []
    var index = IndexPath()
    
    
    // add logo image to navigationbar
    func addNavBarImage() {
        let navController = navigationController!
        navigationController?.navigationBar.barTintColor = UIColor(red:0.27, green:0.45, blue:0.58, alpha:1)
        let image = UIImage(named: "titleLogo.png")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_HELP {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_SETTING {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SETTING, for: indexPath) as! SettingTableViewCell
            cell.iconImage.image = UIImage(named: "language")
            cell.settingItemLabel.text = "Language"
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_HELP, for: indexPath) as! HelpTableViewCell
        cell.helpItemLabel.text = "About Us"
        cell.iconImage.image = UIImage(named: "help")
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SECTION_SETTING{
            return "System Setting"
        }
        return "Help and Information"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SECTION_SETTING {
            return 40
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_SETTING {
            self.pickChoices = ["English", "简体中文", "हिन्दी"]
            let alert = UIAlertController(title: "Select System Language", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            alert.isModalInPopover = true
            let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
            alert.view.addSubview(pickerFrame)
            pickerFrame.dataSource = self
            pickerFrame.delegate = self
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                
                if let cell = self.tableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    
                    if self.pickValue != "" {
                        cell.settingValueLabel.text = self.pickValue
                        //TODO: Change system language
                        }
                    }}))
            
            self.present(alert,animated: true, completion: nil )
        }
        
        
    }
    
    
    //set up picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickChoices[row] )
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickValue = pickChoices[row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}