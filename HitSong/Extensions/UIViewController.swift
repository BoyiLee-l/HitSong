//
//  UIViewController.swift
//  HitSong
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

var spinner: UIActivityIndicatorView = {
       let activityView = UIActivityIndicatorView()
       activityView.style = .gray
       return activityView
   }()

extension UIViewController {
    
    func setBackground(color1: UIColor, color2: UIColor, color3: UIColor){
        let colour1 = color1.cgColor
        let colour2 = color2.cgColor
        let colour3 = color3.cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour3, colour2, colour1]
        gradient.locations = [ 0.4, 0.8,0.9]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK:-ActivityView方法
    func setupActivityView(){
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    func startLoading(){
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    func stopLoading(){
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}
