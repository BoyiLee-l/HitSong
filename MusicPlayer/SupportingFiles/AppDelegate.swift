//
//  AppDelegate.swift
//  HitSong
//
//  Created by user on 2020/8/18.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationBarColor =  UINavigationBar.appearance()
        navigationBarColor.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationBarColor.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBarColor.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)]
        let tabBarColor = UITabBar.appearance()
        tabBarColor.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    }
    
    
    
}



