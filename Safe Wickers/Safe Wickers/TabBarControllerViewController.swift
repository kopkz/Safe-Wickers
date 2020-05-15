//
//  TabBarControllerViewController.swift
//  Safe Wickers
//
//  Created by 郑维天 on 15/5/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.children[0].title = NSLocalizedString("tabBar_find", comment: "tabBar_find")
        self.children[1].title = NSLocalizedString("tabBar_favourite", comment: "tabBar_favourite")
       self.children[2].title = NSLocalizedString("tabBar_compare", comment: "tabBar_compare")
        self.children[3].title = NSLocalizedString("tabBar_sign", comment: "tabBar_sign")
        self.children[4].title = NSLocalizedString("tabBar_setting", comment: "tabBar_setting")
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
