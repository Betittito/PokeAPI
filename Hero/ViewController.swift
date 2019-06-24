//
//  ViewController.swift
//  Hero
//
//  Created by Jesus Alberto Berlanga Reyes on 6/24/19.
//  Copyright © 2019 Jesus Alberto Berlanga Reyes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnPress: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPress.layer.cornerRadius = 15
        
    }

    @IBAction func pressed(_ sender: UIButton) {
        webServices.shared.requestPOSTresponse(link: "pokemon/ditto/", VC: viewController!)
    }
    
}
extension UIResponder {
    var viewController: UIViewController?{
        if let vc = self as? UIViewController {
            return vc
        }
        return next?.viewController
    }
}

