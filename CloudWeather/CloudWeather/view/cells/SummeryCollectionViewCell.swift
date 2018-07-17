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

        guard let weatherItem = forecast.dataArray.last else { return }
        setupTempLabel(weatherItem)
        setupIcon(weatherItem)
        typeDescLbl.text = weatherItem.shortDescription.capitalized
    }

    func setupTempLabel(_: WeatherManager.WeatherItem) {
        //need to capture temp in feed
    }

    func setupIcon(_: WeatherManager.WeatherItem) {
        //need to add icon loader
    }

    func setupDateLabels(_ date: Date) {

        let formatter = DateFormatter()

        formatter.setLocalizedDateFormatFromTemplate("E")
        dayOfWeekLbl.text = formatter.string(from: date)

        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        hourLbl.text = formatter.string(from: date)

    }

}
