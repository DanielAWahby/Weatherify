//
//  Weather.swift
//  SimpleWeatherAPI
//
//  Created by Daniel Wahby on 8/9/20.
//  Copyright © 2020 Daniel Wahby. All rights reserved.
//

import Foundation

struct Weather: Codable {
    var request:WeatherRequest?
    var location:WeatherLocation?
    var current:CurrentWeather?
}

struct WeatherLocation:Codable {
    var name:String?
    var country:String?
}

struct WeatherRequest:Codable {
    var units:String?
}

struct CurrentWeather: Codable {
    var temperature:Int?
    var weather_descriptions:[String]?
}
