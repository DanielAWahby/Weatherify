//
//  WeatherManager.swift
//  Weatherify
//
//  Created by Daniel Wahby on 01/03/2022.
//

import Foundation
import Alamofire
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    // MARK: Define API base URL & APIKey
    var API_Key = "API_KEY"
    var baseURL = "http://api.weatherstack.com/current?access_key=" {
        didSet{}
    }
    
    var weather = Weather()
    
    var delegate : WeatherManagerDelegate?
    
    func getWeatherConditions(long:CLLocationDegrees,lat:CLLocationDegrees,units:Character) {
        
        //                debugPrint(response)
        DispatchQueue.main.async {
            let urlString = "\(baseURL)\(API_Key)&query=\(long),\(lat)&units=\(units)"
            AF.request(urlString ,method: .get,encoding: JSONEncoding.default).responseData { response in
                switch(response.result) {
                case.success(let data):
                    parseJSON(data)
                case .failure:
                    if let responseError = response.error {
                        delegate?.didFailWithError(error: responseError)
                    }
                    break
                }
            }
        }
    }
    
    func parseJSON(_ data:Data){
        _ = JSONDecoder()
        do {
            let weatherData = try JSONDecoder().decode( Weather.self, from: data)
            delegate?.didUpdateWeather(self, weather: weatherData)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func getCurrentUnit(selectedUnitIndex: Int)->Character{
        switch selectedUnitIndex {
        case 0: return "m"
        case 1: return "f"
        case 2: return "s"
        default: return "m"
        }
    }
    
   
}
