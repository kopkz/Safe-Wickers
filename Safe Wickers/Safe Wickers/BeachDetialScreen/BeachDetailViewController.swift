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
    
    @IBOutlet weak var loveUnloveButton: LoveButton!
    //database listener
    var listenerType = ListenerType.lovedBeach
    
    weak var databaseController: DatabaseProtocol?
    var lovedBeachs: [LovedBeach] = []
    
    
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
        navController.navigationBar.backItem?.title = "Back"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up navigation bar
        addNavBarImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
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
        
        loveUnloveButton.isLove = beach!.ifLoved!
        loveUnloveButton.addTarget(self, action: #selector(loveUloveBeach), for: .touchUpInside)
        
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
    
    //love or unlove beach
    
    @objc func loveUloveBeach(){
        if self.beach!.ifLoved!{
            cancelLovedBeach(beachName: self.beach!.beachName!)
        } else{
            addLovedBeach(beach: self.beach!)
        }
    }
    
    func checkIfLoved(beachNmae: String) -> Bool{
        var ifLoved = false
        for beach in lovedBeachs {
            if beach.beachName == beachNmae{
                ifLoved = true
            }
        }
        return ifLoved
    }
    
    // add beach to loved beach database
    func addLovedBeach(beach:Beach) {
        
        let ifLoved = checkIfLoved(beachNmae: beach.beachName!)
        if ifLoved {
            return
        }
        let _ = databaseController!.addLovedBeach(beachName: beach.beachName!, lat: beach.latitude!, long: beach.longitude!, imageName: beach.imageName!, ifGuard: beach.ifGuard!, ifPort: beach.ifPort!)
    }
    
    // remove beach from loved beach database
    func cancelLovedBeach(beachName: String) {
        var unlovedBeach: LovedBeach?
        for beach in lovedBeachs {
            if beach.beachName == beachName{
                unlovedBeach = beach
            }
        }
        guard let unloved = unlovedBeach else {
            return
        }
        
        let _ = databaseController!.deleteLovedBeach(lovedBeach: unloved)
    }
}

extension BeachDetailViewController: DatabaseListener{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onLovedBeachChange(change: DatabaseChange, lovedBeachs: [LovedBeach]) {
        self.lovedBeachs = lovedBeachs
    }
}
