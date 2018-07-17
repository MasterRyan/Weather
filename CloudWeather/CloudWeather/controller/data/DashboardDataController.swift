//
//  DashboardDataController.swift
//  CloudWeather
//
//  Created by matthew.ryan on 7/17/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class DashboardDataController: UIViewController {
    
    var fiveDayData: WeatherManager.Forecast? {
        didSet {
            refresh()
        }
    }
    var currentWeather: WeatherManager.Weather?{
        didSet {
            refresh()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataIfNeeded(force: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadDataIfNeeded(force: Bool) {
        
        WeatherManager.fivedayForcast { [unowned self](forecast, error) in
            if let error = error {
                self.display(error: error)
                return
            }
            self.fiveDayData = forecast
        }
        
        WeatherManager.forecastNow { [unowned self](forecast, error) in
            if let error = error {
                self.display(error: error)
                return
            }
            self.currentWeather = forecast
        }
    }
    
    func refresh() {
        //place holder for ui controller.
    }
    
    func display(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
