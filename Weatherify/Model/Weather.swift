//
//  Weather.swift
//  SimpleWeatherAPI
//
//  Created by Daniel Wahby on 8/9/20.
//  Copyright © 2020 Daniel Radtke. All rights reserved.
//

import UIKit

struct Weather: Codable {
    var request:WeatherRequest?
    var location:WeatherLocation?
    var current:CurrentWeather?
    
    func getFullLocation()->String?{
        return "\(location?.name ?? ""), \(location?.country ?? "")"
    }
    
    func getTemperatureString()->String{
        return "\(current?.temperature ?? 0)°"
    }
    func getWeatherIcon()->UIImage?{
        if let weatherDescription = current?.weather_descriptions?.first?.lowercased(){
            if weatherDescription.contains("partly"){
                return UIImage(named:"Partly Cloudy")
            }
            else if weatherDescription.contains("sunny"){
                if weatherDescription.contains("cloud"){
                    return UIImage(named:"Partly Cloudy")
                }
                return UIImage(named:"Sunny")
            }
            else if weatherDescription.contains("fog") || weatherDescription.contains("haze"){
                return UIImage(named:"Foggy")
            }
            else if weatherDescription.contains("thunder") ||  weatherDescription.contains("lightning"){
                return UIImage(named:"Lightning")
            }
            else if weatherDescription.contains("snow") || weatherDescription.contains("hail"){
                return UIImage(named:"Snowy")
            }
            else if weatherDescription.contains("rain"){
                return UIImage(named:"Rainy")
            }
            else if weatherDescription.contains("mist"){
                return UIImage(named: "Mist")
            }
            else{
                return UIImage(named:"Windy")
            }
        }
        else{
            return nil
        }
    }
}
