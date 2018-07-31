//
//  LoadingViewController.swift
//  CloudWeather
//
//  Created by matthew.ryan on 7/16/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO Pre Cache if time Left
        //simulate pre-cache with delay
        perform(#selector(self.moveToDash), with: nil, afterDelay: 5)
    }

    @objc func moveToDash() {
        //performSegue(withIdentifier: "MOVE_TO_APP_SEGUE", sender: nil)
    }

}
