//
//  SummeryCollectionViewCell.swift
//  CloudWeather
//
//  Created by user141656 on 7/17/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class SummeryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var typeDescLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var dayOfWeekLbl: UILabel!

    func setup(with forecast: WeatherManager.ForecastItem) {
        //dates
        let date = Date(timeIntervalSince1970: forecast.datetime)

        setupDateLabels(date)

        guard let weatherItem = forecast.dataArray.first else { return }
        setupTempLabel(forecast)
        setupIcon(weatherItem.icon)
        typeDescLbl.text = weatherItem.shortDescription.capitalized
    }

    func setupTempLabel(_ itemData: WeatherManager.ForecastItem) {
        guard let kelvin = itemData.main.temp else { return }
        tempLbl.text = "\(Int(kelvin-273.15))ºc"
    }

    func setupIcon(_ iconId: String) {
        WeatherManager.loadImage(iconId) { (image, error) in
            if error != nil {
                self.iconImgView.image = nil
                return
            }
            guard let image = image else { return }

            self.iconImgView.image = image
        }
    }

    func setupDateLabels(_ date: Date) {

        let formatter = DateFormatter()

        formatter.setLocalizedDateFormatFromTemplate("E")
        dayOfWeekLbl.text = formatter.string(from: date)

        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        hourLbl.text = formatter.string(from: date)

    }

}
