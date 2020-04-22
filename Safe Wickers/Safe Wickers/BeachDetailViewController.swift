//
//  BeachDetailViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 22/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class BeachDetailViewController: UIViewController {
    @IBOutlet weak var beachImageView: UIImageView!
    @IBOutlet weak var beachNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var beachDesTextView: UITextView!
    
    @IBOutlet weak var beachInfoTableView: UITableView!
    
    var beach: Beach?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beachNameLabel.text = beach?.beachName
        distanceLabel.text = "\((beach?.distance!)!/1000) km"
        beachDesTextView.text = beach?.descrip
        
        //TODO load real image
        beachImageView.image = UIImage(named: beach!.imageName!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
