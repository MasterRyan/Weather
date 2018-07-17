//
//  WeatherManager.swift
//  CloudWeather
//
//  Created by Matthew Ryan on 7/16/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

//TODO add Cache for offline support if have time.

class WeatherManager: NSObject {
    
    private static let baseUrlString = "http://api.openweathermap.org/data/2.5/"
    private static let nowEndPoint = "weather"
    private static let fiveDayEndPoint = "forecast"
    private static let location = URLQueryItem(name: "q", value: "Manchester,UK")
    private static let apiKey = URLQueryItem(name: "APPID", value:"aa62179fbad60eba69a3f32fc4a6b8dc")
    
    struct Coord: Decodable {
        let lat: Double!
        let lon: Double!
    }
    
    struct WeatherItem: Decodable {
        let shortDescription: String!
        let fullDescription: String!
        let icon: String!
        
        private enum CodingKeys: String, CodingKey {
            case shortDescription = "main"
            case fullDescription = "description"
            case icon
        }
    }
    
    struct Weather: Decodable {
        let coord: Coord!
        let dataArray: [WeatherItem]!
        
        private enum CodingKeys: String, CodingKey {
            case coord
            case dataArray = "weather"
        }
    }
    
    struct Forecast: Decodable {
        let list: [ForecastItem]!
    }
    
    struct ForecastItem: Decodable {
        let datetime: Date!
        let dataArray: [WeatherItem]!
        
        private enum CodingKeys: String, CodingKey {
            case datetime = "dt"
            case dataArray = "weather"
        }
    }
    
    static func fivedayForcast(_ completionHandler: @escaping (Forecast?, Error?) -> Void) {
        
        update(with: fiveDayEndPoint) { (data, responce, error) in
            guard let data = data else { return } //TODO call compHandler with error
            
            //TODO move decode to a more generic function
            do {
                let decoder = JSONDecoder()
                let forecast = try? decoder.decode(Forecast.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(forecast, error)
                }
            }
        }
    }
    
    static func forecastNow(_ completionHandler: @escaping (Weather?, Error?) -> Void) {
        
        update(with: nowEndPoint) { (data, responce, error) in
            
            guard let data = data else { return } //TODO call compHandler with error
            
            //TODO move decode to a more generic function
            do {
                let decoder = JSONDecoder()
                let forecast = try? decoder.decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(forecast, error)
                }
            }
        }
    }
    
    private static func update(with endpoint: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var urlComps = URLComponents(string: baseUrlString+endpoint)
        urlComps?.queryItems = [apiKey,location]
        
        guard let url = urlComps?.url else { return } //TODO call compHandler with error

        let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        
        task.resume()
    }
}
