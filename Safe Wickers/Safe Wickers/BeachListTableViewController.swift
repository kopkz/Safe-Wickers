//
//  BeachListTableViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 20/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit
import MapKit

class BeachListTableViewController: UITableViewController {
    
    var regionLocation: CLLocationCoordinate2D?
    var matchingItems:[MKMapItem] = []
    var beachList:[Beach] = []
    var fliteredList:[Beach] = []
    var activityName: String?
    
    let SECTION_SETTING = 0
    let SECTION_BEACH = 1
    let SECTION_COUNT = 2
    let CELL_SETTING = "settingCell"
    let CELL_BEACH = "beachCell"
    let CELL_COUNT = "countCell"
    
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
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        getBeachLocationList()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // load other beach info, such as image,distance,etc
    func loadBeachInfo(){
        for item in matchingItems{
            let beachName = item.name
            let latitude = item.placemark.coordinate.latitude
            let longitude = item.placemark.coordinate.longitude
            let distance = item.placemark.location?.distance(from: CLLocation(latitude: regionLocation!.latitude, longitude: regionLocation!.longitude)).rounded()
            
            let ifGuard = checkIfGuard(beach: item)
            let ifPort = checkIfPort(beach: item)
            
            //TODO load internet iamge
            let imageName = "defaultBeachImage.jpg"
            
            let beach = Beach(beachName: beachName!, latitude: latitude, longitude: longitude, imageName: imageName, distance: distance!, risk: "", ifGuard: ifGuard, ifPort: ifPort)
            
            beachList.append(beach)
            
        }
    }
    
    //TODO check the beach if have lifeguard
    func checkIfGuard(beach: MKMapItem) -> Bool{
        return true
    }
    
    //TODO check the beach if have port
    func checkIfPort(beach: MKMapItem) -> Bool{
        return true
    }
    
    //sort the list
    func sortList(){
        // sort according to alphabetical order
        fliteredList = beachList.sorted(){ $0.beachName!.lowercased() > $1.beachName!.lowercased()}
        
        // sort by distance
        fliteredList = beachList.sorted(){ $0.distance!.isLess(than:$1.distance!)}
    }
    
    func fliterList(){
        // safe or unsafe
        fliteredList = beachList.filter({(beach: Beach) -> Bool in
            return beach.risk?.contains("s") ?? false
        })
        
    }
    
    // serch neaby beach
    func getBeachLocationList() {
      
        //create request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "beach"
        searchRequest.region = MKCoordinateRegion.init(center: regionLocation!, latitudinalMeters: 50000, longitudinalMeters: 50000)
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        //start search
        activeSearch.start { (response, error) in
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Getting data
                self.matchingItems = response!.mapItems
                self.loadBeachInfo()
                self.fliteredList = self.beachList
                self.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_BEACH {
            return fliteredList.count
        } else{
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...

        if indexPath.section == SECTION_SETTING{
            let settingCell = tableView.dequeueReusableCell(withIdentifier: CELL_SETTING, for: indexPath)
            settingCell.textLabel?.text = " \(String(describing: activityName))TODO: filter button"
            return settingCell
        }
        if indexPath.section == SECTION_COUNT{
            let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
            
            countCell.textLabel?.text = "\(fliteredList.count) beaches in the database"
            return countCell
        }
        
            let beachCell = tableView.dequeueReusableCell(withIdentifier: CELL_BEACH, for: indexPath) as! BeachListTableViewCell
            let beach = fliteredList[indexPath.row]
            
            beachCell.beachNameLabel.text = beach.beachName
            beachCell.distanceLabel.text = "\(beach.distance!/1000) km"
            beachCell.beachImage.image = UIImage(named: beach.imageName!)
            
            return beachCell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_BEACH{
            return 300
        }
        return 45
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
