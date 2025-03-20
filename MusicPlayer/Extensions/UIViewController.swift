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
       activityView.style = .medium
       return activityView
   }()

extension UIViewController {
    
    func setBackgroundColor(color1: UIColor, color2: UIColor, color3: UIColor){
        let colour1 = color1.cgColor
        let colour2 = color2.cgColor
        let colour3 = color3.cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour3, colour2, colour1]
        gradient.locations = [ 0.4, 0.9, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK:-ActivityView方法
    func setupActivityView(){
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    func startLoading(){
        DispatchQueue.main.async {
            spinner.startAnimating()
            spinner.isHidden = false
        }
    }
    
    func stopLoading(){
        DispatchQueue.main.async {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    func alert(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
}
