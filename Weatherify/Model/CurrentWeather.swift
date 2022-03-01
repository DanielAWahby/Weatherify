//
//  CurrentWeather.swift
//  SimpleWeatherAPI
//
//  Created by Daniel Wahby on 8/9/20.
//  Copyright © 2020 Daniel Radtke. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    var temperature:Int?
    var weather_descriptions:[String]?
}
