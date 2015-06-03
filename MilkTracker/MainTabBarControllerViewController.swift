//
//  MainTabBarControllerViewController.swift
//  MilkTracker
//
//  Created by Yi Qin on 6/3/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.translucent = true
        tabBar.barTintColor = lightWhite
        tabBar.tintColor = lightRed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
