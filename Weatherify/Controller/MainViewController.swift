//
//  ViewController.swift
//  SimpleWeatherAPI
//
//  Created by Daniel Wahby on 8/9/20.
//  Copyright © 2020 Daniel Wahby. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class MainViewController: UIViewController {
    
    var locationManager : CLLocationManager?
    var weatherManager = WeatherManager()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var unitConroller: UISegmentedControl!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    // MARK: Handle Unit Changes
    @IBAction func unitChanged(_ sender: Any) {
        handleUnitChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.handleUnitChange()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOADED")
        activity.isHidden = false
        activity.startAnimating()
        self.title = "Simple Weather"
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "CustomBlue")]
        let secondTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        unitConroller.setTitleTextAttributes(titleTextAttributes, for: .selected)
        unitConroller.setTitleTextAttributes(secondTitleTextAttributes, for: .init())
        
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        weatherManager.delegate = self
    }
    func handleUnitChange(){
        if !activity.isAnimating{
            locationManager?.startUpdatingLocation()
        }
    }
}
//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        activity.startAnimating()
        guard let first = locations.first else {
            return
        }
        weatherManager.getWeatherConditions(long: first.coordinate.longitude, lat: first.coordinate.latitude, units: weatherManager.getCurrentUnit(selectedUnitIndex: unitConroller.selectedSegmentIndex))
        self.locationManager?.stopUpdatingLocation()
    }
}

extension MainViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather) {
        DispatchQueue.main.async {[self] in
            cityLabel.text = weather.getFullLocation()
            temperatureLabel.text = weather.getTemperatureString()
            weatherIcon.image = weather.getWeatherIcon()
            activity.stopAnimating()
        }
    }
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {[self] in
            weatherIcon.image = UIImage(named: "error")
            activity.stopAnimating()
        }
        print(error)
    }
}

