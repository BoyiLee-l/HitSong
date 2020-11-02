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
        // Override point for customization after application launch.
//        if Status.shared.jsonData != nil || Status.shared.remoteStarted{
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            let switchVC = SwitchVC()
//            if let ovc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController(){
//                switchVC.shellVC = ovc // the first ViewController
//            }
//            self.window?.rootViewController = switchVC
//            self.window?.makeKeyAndVisible()}
        let navigationBarColor =  UINavigationBar.appearance()
        navigationBarColor.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationBarColor.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBarColor.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)]
        let tabBarColor = UITabBar.appearance()
        tabBarColor.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
//        guard let fun = FunVCSingleton else{
//            return
//        }
//        fun.stopBackGroundUrlCheck()
//        fun.stopProgFetch()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        
//        if let lastPresentUrl = MainWebView?.url{
//            PresentingURL = lastPresentUrl
//        }
//        AppDuringUsage = false
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        
//        AppDuringUsage = true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
//        application.applicationIconBadgeNumber = 0
//        if DidReceiveMemoryWarningBackground && PresentingURL != nil{
//            MainWebView?.load(URLRequest(url: PresentingURL!))
//            print("Trig WebView reload due to MemoryWarning")
//            DidReceiveMemoryWarningBackground = false
//        }
//        guard let fun = FunVCSingleton else{
//            return
//        }
//        fun.startBackgroundUrlCheck()
//        fun.startProgFetch()
    }
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
//        print("didReciveMemoryWarning, AppDuringUsage = ",AppDuringUsage)
//        if !AppDuringUsage{DidReceiveMemoryWarningBackground = true}
    }
    
    
    
}



