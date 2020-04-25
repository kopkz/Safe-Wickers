//
//  BeachDetailViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 22/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit
import SDWebImage


class BeachDetailViewController: UIViewController {
    @IBOutlet weak var beachImageView: UIImageView!
    @IBOutlet weak var beachNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ifPortImageView: UIImageView!
    @IBOutlet weak var ifGuardImageView: UIImageView!
    @IBOutlet weak var windSpeedValue: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var tempValue: UILabel!
    
    @IBOutlet weak var humLabel: UILabel!
    
    @IBOutlet weak var humValue: UILabel!
    
    @IBOutlet weak var preLabel: UILabel!
    var beach: Beach?
    @IBOutlet weak var preValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beachNameLabel.text = beach?.beachName
        distanceLabel.text = "\((beach?.distance!)!/1000) km"
        windSpeedValue.text = "\(beach!.windSpeed!) m/s"
        if beach!.ifGuard! {
            ifGuardImageView.image = UIImage(named: "yes")
        }else{
            ifGuardImageView.image = UIImage(named: "no")
        }
        if beach!.ifPort! {
            ifPortImageView.image = UIImage(named: "yes")
        }else{
            ifPortImageView.image = UIImage(named: "no")
        }
        
        //TODO load real image
        //beachImageView.image = UIImage(named: beach!.imageName!)
        let url = URL(string: (beach?.imageName!)!)
        
       beachImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultBeachImage.jpg"), completed: nil)
        let tempC = beach!.temp! - 273.15
        tempValue.text = "\(tempC.rounded()) ℃"
        humValue.text = "\(beach!.hum!) %"
        preValue.text = "\(beach!.pre!) hpa"
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
