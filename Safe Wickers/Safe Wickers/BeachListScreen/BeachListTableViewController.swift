//
//  BeachListTableViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 20/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
import CoreData

class BeachListTableViewController: UITableViewController{
    
    weak var databaseController: DatabaseProtocol?
    //database listener
    var listenerType = ListenerType.lovedBeach
    var lovedBeachs:[LovedBeach] = []
    
    var regionLocation: CLLocationCoordinate2D?
    var matchingItems:[MKMapItem] = []
    var beachList:[Beach] = []
    var fliteredList:[Beach] = []
    var activityName: String?
    var indicator = UIActivityIndicatorView()
    var imageURLs:[String] = []
    var lifeGuardLoactions:[String] = []
    
    let weatherApiID = "da9c3535ceb9e41bb432c229b579f2a8"
    
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
        navController.navigationBar.backItem?.title = "Back"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //edit navi bar
        addNavBarImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //create a loading animation
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
       
        lifeGuardLoactions = lifeGuardLoaction()
        //get beach info
        getBeachLocationList()
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
       
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        //create a loading animation
//        indicator.style = UIActivityIndicatorView.Style.gray
//        indicator.center = self.tableView.center
//        self.view.addSubview(indicator)
//
//        //loadImage()
//    }
    
    
    
    // load other beach info, such as image,distance,etc
    func loadBeachInfo(){
        for item in matchingItems{
            let beachName = item.name
            let latitude = item.placemark.coordinate.latitude
            let longitude = item.placemark.coordinate.longitude
            let distance = item.placemark.location?.distance(from: CLLocation(latitude: regionLocation!.latitude, longitude: regionLocation!.longitude)).rounded()
            
            let ifGuard = checkIfGuard(beach: item)
            let ifPort = checkIfPort(beach: item)
            
            //TODO load internet iamge, risk(wind), descip
            
            let imageNmae = searchIamgeOnline(beach: "\(beachName!) Victoria")
            
//            let des = item.placemark.locality ?? ""
            let weatherData = getCurrentWeatherDate(beach: item)
            let windSpeed = weatherData[0]
            let temp = weatherData[1]
            let hum = weatherData[2]
            let pre = weatherData[3]
            
            
            let risk = chechRisk(ifPort: ifPort, ifGuard: ifGuard, windSpeed: windSpeed)
            
            let ifLoved = checkIfLoved(beachNmae: beachName!)
           
            let beach = Beach(beachName: beachName!, latitude: latitude, longitude: longitude, imageName: imageNmae, distance: distance!, risk: risk, ifGuard: ifGuard, ifPort: ifPort, descrip: "", windSpeed: windSpeed, temp: temp, hum: hum, pre: pre, ifLoved: ifLoved)
            
            beachList.append(beach)
        }
        
    }
    
    //chech the risk according to activity, wind , guard, port
    
    func chechRisk(ifPort: Bool, ifGuard: Bool, windSpeed: Double) -> String{
        var risk = "u"
        if activityName == "Boating" {
            if ifPort{
                    if (windSpeed*2.237).isLess(than: 39) && windSpeed != 0.0 {
                        risk = "s"
                }
            }
        }
        
        if activityName == "Surfing" {
           if ifGuard{
                if (windSpeed*2.237).isLess(than: 20) && windSpeed != 0.0 {
                    risk = "s"
                }
            }
        }
        if activityName == "Swimming" {
        if ifGuard{
            if (windSpeed*2.237).isLess(than: 9) && windSpeed != 0.0 {
                risk = "s"
                }
            }
        }
        return risk
    }
    
    
    
//    func loadImage(){
//    // start anminating the loading as the URL request is made
//    indicator.startAnimating()
//    indicator.backgroundColor = UIColor.white
//
//        for beach in beachList{
//            searchIamgeOnline(beach: beach.beachName!)
//        }
//        if beachList.count == imageURLs.count {
//            var index = 0
//            while index < beachList.count{
//                beachList[index].imageName = imageURLs[index]
//                index = index + 1
//            }
//        }
//
//        // Regardless of response end the loading icon from the main thread
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//
//            self.indicator.stopAnimating()
//            self.indicator.hidesWhenStopped = true
//        }
//
//    }

  
    
    func searchIamgeOnline(beach: String) -> String {
        var beachImageURL: String?

        //key:   AIzaSyBDczIvDMC85RvOC1lKpxUGB50GH4mD6yc    AIzaSyBcZK2M_pWExrukRTeeMBJ_LgFv13lIVQI

        let searchString = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBDczIvDMC85RvOC1lKpxUGB50GH4mD6yc&cx=002407881098821145824:29fpb6s3hfq&q=\(beach)&searchType=image&num=1"
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//        let task = URLSession.shared.dataTask(with: jsonURL!){
//            (data, response, error) in
//
//
//            // if error, show error message
//            if let error = error {
//                self.displayMessage(title: "Error", message: error.localizedDescription)
//                return
//            }
//
//            do{
//                let decoder = JSONDecoder()
//                let imageDate = try decoder.decode(OnlineImageData.self, from: data!)
//
//                guard let imageURL = imageDate.onlineImages?[0].imageURL else {
//                    return
//                }
//               self.imageURLs.append(imageURL)
//                print(imageURL)
//
//            } catch let err{
//                DispatchQueue.main.async {
//                   self.displayMessage(title: "Error", message: err.localizedDescription)
//                }
//            }
//        }
//        //start the data task
//        task.resume()
        
        guard let urlData = NSData(contentsOf: jsonURL!) else{ return ""}
        
        do{
            let decoder = JSONDecoder()
            let imageDate = try decoder.decode(OnlineImageData.self, from: urlData as Data)
            
            guard let imageURL = imageDate.onlineImages?[0].imageURL else {return ""}
            beachImageURL = imageURL
            
            
        } catch let err{
                            DispatchQueue.main.async {
                               self.displayMessage(title: "Error", message: err.localizedDescription)
                            }
                        }
        return beachImageURL ?? ""
    }

    
    //get weather info of beach
    
    func getCurrentWeatherDate(beach: MKMapItem) -> [Double]{
        var weatherData: [Double] = []
        let lat = beach.placemark.location?.coordinate.latitude
        let long = beach.placemark.location?.coordinate.longitude
        
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat!)&lon=\(long!)&appid=\(weatherApiID)"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        guard let weatheData = NSData(contentsOf: url!) else {
            return []
        }
        
        
                                    do{
                                        let decoder = JSONDecoder()
                                        let weather = try decoder.decode(WeatherURLData.self, from: weatheData as Data)
                                        weatherData.append(weather.windSpeed)
                                         weatherData.append(weather.temp)
                                         weatherData.append(weather.humidity)
                                         weatherData.append(weather.pressure)
                                    } catch let err{
                                        DispatchQueue.main.async {
                                           self.displayMessage(title: "Error", message: err.localizedDescription)
                                        }
                                    }
                
//       let task = URLSession.shared.dataTask(with: url!){
//                    (data, response, error) in
//                    // if error, show error message
//                    if let error = error {
//                        self.displayMessage(title: "Error", message: error.localizedDescription)
//                        return
//                    }
//
//                    do{
//                        let decoder = JSONDecoder()
//                        let weather = try decoder.decode(WeatherURLData.self, from: data!)
//                        print(weather.temp)
//
//                    } catch let err{
//                        DispatchQueue.main.async {
//                           self.displayMessage(title: "Error", message: err.localizedDescription)
//                        }
//                    }
//                }
//        task.resume()
        return weatherData
    }
    
    
    
    
    
    
    // check the beach if have lifeguard
    func checkIfGuard(beach: MKMapItem) -> Bool{
        if let  lgLocation = beach.placemark.subLocality {
            return lifeGuardLoactions.contains(lgLocation)
        }
        return false
    }
    
    
    
    
    //check the beach if have port
    func checkIfPort(beach: MKMapItem) -> Bool{
        
        let melPort = CLLocation(latitude: -37.8432094464, longitude: 144.9267604579)
        let welPort = CLLocation(latitude: -38.694353, longitude: 146.466637)
        let geePort = CLLocation(latitude: -38.116666667, longitude: 144.383333333)
        let portPort = CLLocation(latitude: -38.35, longitude: 141.616666667)

        if (beach.placemark.location?.distance(from: melPort).isLess(than: 5000))! {
            return true
        }
        if (beach.placemark.location?.distance(from: welPort).isLess(than: 5000))! {
            return true
        }
        if (beach.placemark.location?.distance(from: geePort).isLess(than: 5000))! {
            return true
        }
        if (beach.placemark.location?.distance(from: portPort).isLess(than: 5000))! {
            return true
        }
        
        return false
    }
    
    //sort the list
    func sortListByLetter(){
        // sort according to alphabetical order
        fliteredList = beachList.sorted(){ $0.beachName!.lowercased() < $1.beachName!.lowercased()}
        self.tableView.reloadData()
    }
    
    
    
    // sort by distance
    func sortListByDistance(){
        // sort according to alphabetical order
        fliteredList = beachList.sorted(by: {$0.distance! < $1.distance!})
        
//       fliteredList = beachList.sorted(){ String(format: "%f",$0.distance!) < String(format: "%f",$1.distance!) }
         self.tableView.reloadData()
    }
   
    
    func fliterList(){
        // safe or unsafe
        fliteredList = beachList.filter({(beach: Beach) -> Bool in
            return beach.risk?.contains("s") ?? false
        })
         self.tableView.reloadData()
    }
    
    // serch neaby beach
    func getBeachLocationList() {
      
        //create request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "beach"
        searchRequest.region = MKCoordinateRegion.init(center: regionLocation!, latitudinalMeters: 20000, longitudinalMeters: 20000)
        
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
                self.indicator.stopAnimating()
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
            let settingCell = tableView.dequeueReusableCell(withIdentifier: CELL_SETTING, for: indexPath) as! FilterButtonTableViewCell
            //settingCell.textLabel?.text = " \(String(describing: activityName))TODO: filter button"
            settingCell.delegate = self
            return settingCell
        }
        if indexPath.section == SECTION_COUNT{
            let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
            
            countCell.textLabel?.text = "\(fliteredList.count) beaches are fund in the area."
            return countCell
        }
        
            let beachCell = tableView.dequeueReusableCell(withIdentifier: CELL_BEACH, for: indexPath) as! BeachListTableViewCell
       
            let beach = fliteredList[indexPath.row]
            beachCell.delegate = self
            beachCell.setBeach(beach: beach)
            beachCell.loveUnloveButton.imageView?.image = beach.ifLoved! ? UIImage(named: "icons8-like-96-2") : UIImage(named: "icons8-unlike-96")
        
            //beach.beachName
            beachCell.beachNameLabel.text = beach.beachName
            beachCell.distanceLabel.text = "\(beach.distance!/1000) km"
        //
        // load image online
            //beachCell.beachImage.image = UIImage(named: beach.imageName!)
        let url = URL(string: beach.imageName!)
       
        beachCell.beachImage!.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultBeachImage.jpg"), completed: nil)
        if beach.risk == "s" {
              beachCell.riskImageView.image = UIImage(named: "safe")
        }else {
            beachCell.riskImageView.image = UIImage(named: "unsafe")
        }
            return beachCell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_BEACH{
            return 300
        }
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_BEACH{
//            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "listToBeachDetail", sender: self)
        }
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

    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMapSegue" {
           let destination = segue.destination as! MapViewController
            destination.focusLocation = CLLocation(latitude: regionLocation!.latitude, longitude: regionLocation!.longitude)
            destination.beachList = fliteredList
        }
        if segue.identifier == "listToBeachDetail" {
            let destination = segue.destination as! BeachDetailViewController
            let index = tableView.indexPathForSelectedRow?.row
            destination.beach = fliteredList[index!]
        }
    }
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func lifeGuardLoaction() -> [String] {
        if let path = Bundle.main.path(forResource: "lg_suburbs", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:String]]
                
                var countryNames = [String]()
                for country in jsonResult {
                    countryNames.append(country["lg_suburb"]!)
                }
                
                return countryNames
            } catch {
                print("Error parsing jSON: \(error)")
                return []
            }
        }
        return []
    }
    
    
}

extension BeachListTableViewController: FilterCellDelegate {
    func onlyShowSafeBeach() {
        self.fliterList()
    }
    
    func showAllBeach() {
        self.fliteredList = beachList
        self.tableView.reloadData()
    }
    
    func sortingByInitials() {
        self.sortListByLetter()
    }
    
    func sortingByDistance() {
        self.sortListByDistance()
    }
}

extension BeachListTableViewController: DatabaseListener{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onLovedBeachChange(change: DatabaseChange, lovedBeachs: [LovedBeach]) {
        self.lovedBeachs = lovedBeachs
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
    
    func addLovedBeach(beach:Beach) {
        
        let ifLoved = checkIfLoved(beachNmae: beach.beachName!)
        if ifLoved {
            return
        }
        let _ = databaseController!.addLovedBeach(beachName: beach.beachName!, lat: beach.latitude!, long: beach.longitude!, imageName: beach.imageName!, ifGuard: beach.ifGuard!, ifPort: beach.ifPort!)
    }
    
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

extension BeachListTableViewController: LoveBeachDelagate {
  
    func loveUnloveBeach(beach: Beach) {
        if beach.ifLoved! {
            cancelLovedBeach(beachName: beach.beachName!)
        }else {
            addLovedBeach(beach: beach)
        }
        tableView.reloadData()
    }
}
