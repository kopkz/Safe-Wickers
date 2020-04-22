//
//  Beach.swift
//  Safe Wickers
//
//  Created by 匡正 on 21/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class Beach: NSObject {
    var beachName: String?
    var latitude: Double?
    var longitude: Double?
    var imageName: String?
    var distance: Double?
    var risk: String?
    var ifGuard: Bool?
    var ifPort: Bool?
    var descrip: String?
    
    init(beachName: String, latitude: Double, longitude: Double, imageName: String, distance: Double, risk: String, ifGuard: Bool, ifPort: Bool, descrip: String) {
        self.beachName = beachName
        self.latitude = latitude
        self.longitude = longitude
        self.imageName = imageName
        self.distance = distance
        self.risk = risk
        self.ifGuard = ifGuard
        self.ifPort = ifPort
        self.descrip = descrip
    }
    
}
