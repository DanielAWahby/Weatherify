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
    // MARK: Define API EndPoint & Params
           var YOUR_ACCESS_KEY = "b7b94d47b557fe41ed9220a9a6140e9b"
           var API_Endpoint = "http://api.weatherstack.com/current?access_key=" {
                didSet{}
            }
//           var units = "m"
           var city = ""
           var currentTemperatureInCelsuis = 0
           var locationManager : CLLocationManager?
           var weather = Weather()
    
    @IBOutlet weak var clothesBtn: UIBarButtonItem!
    
    
//    @IBAction func toggleDarkModeAction(_ sender: Any) {
//        self.navigationController?.navigationBar.backgroundColor = .white
//    }
//    @IBOutlet weak var darkModeToggle: UIBarButtonItem!

//    @IBOutlet weak var searchButton: UIBarButtonItem!
//    @IBOutlet weak var searchBar: UISearchBar!
//
//    @IBAction func triggerSearch(_ sender: Any) {
//        self.searchBar.isHidden = !self.searchBar.isHidden
//    }
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var unitConroller: UISegmentedControl!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    // MARK: Handle Unit Changes
    @IBAction func unitChanged(_ sender: Any) {
        handleUnitChange()
        
//        getWeatherConditions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        print("Unit: ",UserDefaults.standard.string(forKey: "unit")!)
        if UserDefaults.standard.string(forKey: "unit") != nil {
            switch UserDefaults.standard.string(forKey: "unit")!{
                case "Fahrenhiet":
                    self.unitConroller.selectedSegmentIndex = 1
                    break
                default:
                    self.unitConroller.selectedSegmentIndex = 0
                }
                self.handleUnitChange()
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOADED")
        activity.isHidden = false
        activity.startAnimating()
        self.title = "Simple Weather"
//        self.searchBar.isHidden = true
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "CustomBlue")]
        let secondTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        unitConroller.setTitleTextAttributes(titleTextAttributes, for: .selected)
        unitConroller.setTitleTextAttributes(secondTitleTextAttributes, for: .init())
        API_Endpoint = "\(API_Endpoint)\(YOUR_ACCESS_KEY)"
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            if error != nil {
                UIApplication.shared.applicationIconBadgeNumber = UserDefaults.standard.integer(forKey: "currentWeatherConditions")
            }
        }
//        getWeatherConditions()
    }
    func handleUnitChange(){
        if !activity.isAnimating{
            if unitConroller.selectedSegmentIndex == 0 {
                UserDefaults.standard.setValue("Celsius", forKey: "unit")
                self.temperatureLabel.text = "\(self.currentTemperatureInCelsuis)°"
                UserDefaults.standard.setValue(self.currentTemperatureInCelsuis, forKey: "currentWeatherConditions")
                UIApplication.shared.applicationIconBadgeNumber = currentTemperatureInCelsuis

            }
            else if unitConroller.selectedSegmentIndex == 1 {
                UserDefaults.standard.setValue("Fahrenhiet", forKey: "unit")
                let weatherFahrenheit = (Int(Double(self.currentTemperatureInCelsuis) * 1.8) + 32)
                self.temperatureLabel.text = "\(weatherFahrenheit)°"
                UserDefaults.standard.setValue(weatherFahrenheit, forKey: "currentWeatherConditions")
                UIApplication.shared.applicationIconBadgeNumber = weatherFahrenheit

            }
            else{
                UserDefaults.standard.setValue("Kelvin", forKey: "unit")
                let weatherKelvin = (Int(Double(self.currentTemperatureInCelsuis))+273)
                self.temperatureLabel.text = "\(weatherKelvin)°"
                UserDefaults.standard.setValue(weatherKelvin, forKey: "currentWeatherConditions")
                UIApplication.shared.applicationIconBadgeNumber = weatherKelvin

            }
        }
    }
    func getWeatherConditions() {

    //                debugPrint(response)
        DispatchQueue.main.async {
            
            AF.request(self.API_Endpoint ,method: .get,encoding: JSONEncoding.default).responseData { response in
                debugPrint(response)
                switch(response.result) {
                case.success(let data):
                              print("success",data)
                    guard let ar = try? JSONDecoder().decode( Weather.self, from: data)  else {
                 debugPrint(" Can't parse json", data.self)
                  return
                  }
                    self.weather = ar
                    self.activity.stopAnimating()
                    let currentWeather = self.weather.current!
                    
                    let weatherLocation = self.weather.location!
                    
                    // MARK: Assigning Response to UI Elements
                    self.setWeatherIcon(description: (currentWeather.weather_descriptions![0]))
                    self.cityLabel.text = "\(weatherLocation.name!), \(weatherLocation.country!)"
                    self.temperatureLabel.text = "\(currentWeather.temperature!)°"
                    self.currentTemperatureInCelsuis = currentWeather.temperature!
                    UIApplication.shared.applicationIconBadgeNumber = self.currentTemperatureInCelsuis
                case .failure: break
                }
            }
        }
    }
////
    func setWeatherIcon(description:String){
        if description == "Clear"{
            self.weatherIcon.image = UIImage(named: "Sunny" ?? "error")
            return
        }
        self.weatherIcon.image = UIImage(named: description ?? "error")
    }
}

    extension MainViewController: CLLocationManagerDelegate{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            activity.startAnimating()
            var finalCityName = ""
            guard let first = locations.first else {
                return
            }
            if CLLocationManager.locationServicesEnabled(){
                let location = CLLocation(latitude: first.coordinate.latitude, longitude: first.coordinate.longitude)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        return
                    }else if let country = placemarks?.first?.country,
                        let currentCity = placemarks?.first?.administrativeArea {
                        finalCityName = "&query=\(currentCity)"
                        self.API_Endpoint = "\(self.API_Endpoint)\(finalCityName)"
                        self.getWeatherConditions()
                        self.handleUnitChange()
                    }
                })
            }
            self.locationManager?.stopUpdatingLocation()
        }
}
