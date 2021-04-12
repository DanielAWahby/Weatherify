//
//  WeatherRequest.swift
//  SimpleWeatherAPI
//
//  Created by Daniel Wahby on 8/9/20.
//  Copyright © 2020 Daniel Radtke. All rights reserved.
//

import Foundation

struct WeatherRequest:Codable {
    var query:String
    var units:String?
}
