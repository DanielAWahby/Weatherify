//
//  Weather.swift
//  SimpleWeatherAPI
//
//  Created by Daniel Wahby on 8/9/20.
//  Copyright © 2020 Daniel Radtke. All rights reserved.
//

import Foundation

struct Weather: Codable {
    var request:WeatherRequest?
    var location:WeatherLocation?
    var current:CurrentWeather?
    
    
}
