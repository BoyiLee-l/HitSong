//
//  TabbarController.swift
//  HitSong
//
//  Created by user on 2020/8/27.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
class TabbarController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(named: "DarkGreen")
        self.tabBar.unselectedItemTintColor = .white
    }
        
}
