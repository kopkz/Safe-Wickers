//
//  CompareViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 7/5/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
}


