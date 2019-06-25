//
//  generalClass.swift
//  Hero
//
//  Created by Jesus Alberto Berlanga Reyes on 6/25/19.
//  Copyright © 2019 Jesus Alberto Berlanga Reyes. All rights reserved.
//

import UIKit

public protocol ActivityIndicatorPresenter {
    
    /// The activity indicator
    var activityIndicator: UIActivityIndicatorView { get }
    
    /// Show the activity indicator in the view
    func showActivityIndicator()
    
    /// Hide the activity indicator in the view
    func hideActivityIndicator()
}
public extension ActivityIndicatorPresenter where Self: UIViewController {
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.style = .whiteLarge
            self.activityIndicator.color = UIColor(named:"red")
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80) //or whatever size you would like
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
