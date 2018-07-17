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

        //TODO Pre Cache if time
        //simulate precash with delay
        perform(#selector(self.moveToDash), with: nil, afterDelay: 10)
    }

    @objc func moveToDash() {
        performSegue(withIdentifier: "LOADING_TO_DASH_SEGUE", sender: nil)
    }

}

