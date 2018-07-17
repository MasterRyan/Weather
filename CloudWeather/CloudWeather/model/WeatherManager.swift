//
//  WeatherManager.swift
//  CloudWeather
//
//  Created by Matthew Ryan on 7/16/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

//TODO add Cache for offline support if have time.

class WeatherManager: NSObject {
    enum WeatherManagerError: Error {
        case noData(String)
        case netWorkError(String)
    }

    private static let baseUrlString = "http://api.openweathermap.org/data/2.5/"
    private static let nowEndPoint = "weather"
    private static let fiveDayEndPoint = "forecast"
    private static let location = URLQueryItem(name: "q", value: "Manchester,UK")
    private static let apiKey = URLQueryItem(name: "APPID", value: "aa62179fbad60eba69a3f32fc4a6b8dc")

    struct Coord: Decodable {
        let lat: Double!
        let lon: Double!
    }

    struct MainData: Decodable {
        let temp: Double!
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
        let main: MainData!

        private enum CodingKeys: String, CodingKey {
            case coord
            case dataArray = "weather"
            case main
        }
    }

    struct Forecast: Decodable {
        let list: [ForecastItem]!
    }

    struct ForecastItem: Decodable {
        let datetime: TimeInterval!
        let dataArray: [WeatherItem]!
        let main: MainData!

        private enum CodingKeys: String, CodingKey {
            case datetime = "dt"
            case dataArray = "weather"
            case main
        }
    }

    static func loadImage(_ imageId: String, completionHandler: @escaping (UIImage?, Error?) -> Void)  {
        guard let url = URL(string: "http://openweathermap.org/img/w/"+imageId+".png") else {
            completionHandler(nil, WeatherManagerError.netWorkError("invalid image URL"))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                    return
                }
            }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    completionHandler(nil, WeatherManagerError.netWorkError("response code = \(response.statusCode)"))
                }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completionHandler(nil, WeatherManagerError.netWorkError("invalid image data"))

                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(image, nil)
            }

        }.resume()
    }

    static func fivedayForcast(_ completionHandler: @escaping (Forecast?, Error?) -> Void) {

        update(with: fiveDayEndPoint) { (data, error) in
            guard let data = data else {
                completionHandler(nil, WeatherManagerError.noData("API returned no data"))
                return
            }

            //TODO move decode to a more generic function
            do {
                let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(forecast, error)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }

    static func forecastNow(_ completionHandler: @escaping (Weather?, Error?) -> Void) {

        update(with: nowEndPoint) { (data, error) in
            guard let data = data else {
                completionHandler(nil, WeatherManagerError.noData("API returned no data"))
                return
            }

            //TODO move decode to a more generic function
            do {
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(forecast, error)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }

    private static func update(with endpoint: String, completionHandler: @escaping (Data?, Error?) -> Void) {

        var urlComps = URLComponents(string: baseUrlString+endpoint)
        urlComps?.queryItems = [apiKey, location]

        guard let url = urlComps?.url else { return } //TODO call compHandler with error

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completionHandler(nil, WeatherManagerError.netWorkError("response code = \(response.statusCode)"))
                return
            }
            print(response)

            completionHandler(data, nil)

        }

        task.resume()
    }
}
