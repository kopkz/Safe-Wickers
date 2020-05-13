//
//  CompareViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 7/5/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit
import Alamofire

class CompareViewController: UIViewController {

    @IBOutlet weak var activtySegment: UISegmentedControl!
    var tttt: [String:Double] = [:]
    
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
        
        addNavBarImage()
        self.activtySegment.tintColor = UIColor(red:0.27, green:0.45, blue:0.58, alpha:1)
        
        // Do any additional setup after loading the view.
//        let clearImage = UIImage(named: "clearImage")
//        testSlider.setMaximumTrackImage(clearImage, for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // get rating data from mysql database
    func getRating(beachName: String){
        var avRating = 0.0
        //Defined a constant that holds the URL for our web service
        let URL_GET_RATING = "http://172.20.10.3/safe_wickers/v1/getRating.php"
        //creating parameters for the get request
        let parameters : Parameters = ["beach_name" : beachName]
        //Sending http get request
        Alamofire.request(URL_GET_RATING, method: .get, parameters: parameters).responseJSON { response in
            do {
                var ratingStrings: [String] = []
                let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [[String:String]]
                for obj in data{
                    ratingStrings.append(obj["rating_level"]!)
                }
                
                for ratingString in ratingStrings{
                    let rating = Int(ratingString)
                    avRating = avRating + Double(rating!)
                }
                
                avRating = avRating/Double(ratingStrings.count)
                if avRating > 0{
                    self.tttt.updateValue(avRating, forKey: beachName)
                } else {
                    self.tttt.updateValue(0, forKey: beachName)
                }
//                print(self.tttt)
            } catch{}
        }
    }
    
    
    
    //get cuurent tide height
    func getTideHeight(tides: TidesData) -> Double{
        let height = tides.heights![0].height
        return height!
    }
  
    // check cuurnet tide state
    func checkTideState(tides: TidesData) -> String{
        let tide = tides.tides![0]
        
        let tideTimeStamp = tide.tideTimeStamp
        let tideState = tide.tideState
        
        let currentTime = Date()
        let currentTimeStamp = Int(currentTime.timeIntervalSince1970)
        
        let diff = tideTimeStamp! - currentTimeStamp
        
        if diff < 300 {
            return tideState!
        } else if diff < 3600 {
            return "MID TIDE"
        } else if diff < 18000 {
            return "SLACK TIDE"
        } else if diff < 21600 {
            return "MID TIDE"
        } else {
            if tideState == "HIGH TIDE" {
                return "LOW TIDE"
            } else {
                return "HIGH TIDE"
            }
        }
    }

    
  
    func tidesapi(lat: Double, long: Double) -> TidesData{
        var tide: TidesData?
        let sem = DispatchSemaphore.init(value: 0)
        // tides
        let headers = [
            "x-rapidapi-host": "tides.p.rapidapi.com",
            "x-rapidapi-key": "fffef8c1dcmsh4e578ad11989305p1fe58cjsnf0e1f2e55a6b"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tides.p.rapidapi.com/tides?interval=60&duration=1440&latitude=44.414&longitude=-2.097")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in defer {sem.signal()}
            if (error != nil) {
                print(error?.localizedDescription as Any)
            } else {
                do {
//                    let test = try JSONSerialization.jsonObject(with: data!, options: [])
//                    print(test)
                    let decoder = JSONDecoder()
                    tide = try decoder.decode(TidesData.self, from: data!)
//                    tide = tideDatas.tides?[0]
                    
                } catch let err { print(err)
                }
            }
        })
        
        dataTask.resume()
        sem.wait()
        return tide!
    }
    
    
    // get UV data of the beach
    // uv api
    func uvapi(lat: Double, long: Double) -> Double {
        
        var uv: Double?
        let sem = DispatchSemaphore.init(value: 0)
        
        //backup key: 7d473ca9dd980058039404acc2f591c8    52cdda85a1f37c9eedc23a29cc5f5c11
        let headers = [
            "x-access-token": "7d473ca9dd980058039404acc2f591c8"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.openuv.io/api/v1/uv?lat=\(lat)&lng=\(long)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in defer {sem.signal()}
            if (error != nil) {
                print(error?.localizedDescription as Any)
            } else {
                do {
                    
                    let decoder = JSONDecoder()
                    let uvData = try decoder.decode(UVData.self, from: data!)
                    uv = uvData.uv
                    
                } catch let err { print(err)
                }
            }
        })
        
        dataTask.resume()
        sem.wait()
        return uv ?? 6.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


