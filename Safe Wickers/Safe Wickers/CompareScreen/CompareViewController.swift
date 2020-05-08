//
//  CompareViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 7/5/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController {

    @IBOutlet weak var testSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let clearImage = UIImage(named: "clearImage")
        testSlider.setMaximumTrackImage(clearImage, for: .normal)
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
