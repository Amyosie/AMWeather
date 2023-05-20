//
//  ViewController.swift
//  AMWeather
//
//  Created by Yosie Abdul Muzanil on 12/05/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // Main data
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var dateToday: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var titleWeather: UILabel!
    
    // Data Prediction 1 jam kedepan
    @IBOutlet weak var timePredThree: UILabel!
    @IBOutlet weak var iconTempPredThree: UIImageView!
    @IBOutlet weak var tempPredThree: UILabel!
    
    // Data Prediction 2 jam kedepan
    @IBOutlet weak var timePredTwo: UILabel!
    @IBOutlet weak var iconTempPredTwo: UIImageView!
    @IBOutlet weak var tempPredTwo: UILabel!
    
    // Data Prediction 3 jam kedepan
    @IBOutlet weak var timePredOne: UILabel!
    @IBOutlet weak var iconTempPredOne: UIImageView!
    @IBOutlet weak var tempPredOne: UILabel!
    
    
    // Text field untuk input nama city yang akan dicari
    @IBOutlet weak var searchTextField: UITextField!
    
    //
    var apiManager = APIController()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for getting app location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        apiManager.delegate = self
        searchTextField.delegate = self
        let myColor : UIColor = UIColor.black
        searchTextField.layer.borderColor = myColor.cgColor
        searchTextField.layer.borderWidth = 2.0
    }
    
    // Location button
    @IBAction func myLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

extension ViewController : UITextFieldDelegate {
    
    // Search button
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            apiManager.getFullApiPath(city)
        }
        searchTextField.text = ""
    }
}

extension ViewController : WeatherProtocol {
    func updateUI(_ data: WeatherDataModelApi) {
        DispatchQueue.main.async {
            
            // change main data
            self.temperature.text = String(data.current.temp_str)
            self.dateToday.text = data.location.localtime
            self.iconWeather.image = UIImage(named: data.current.condition.icon)
            self.titleWeather.text = data.current.condition.text
            self.city.text = data.location.name
            
            // change data 1 jam kedepan
            self.tempPredOne.text = "\(data.forecast.forecastday[0].hour[0].temp_str) C"
            self.iconTempPredOne.image = UIImage(named: data.forecast.forecastday[0].hour[0].condition.icon)
            self.timePredOne.text = data.forecast.forecastday[0].hour[0].time
            
            // change data 2 jam kedepan
            self.tempPredTwo.text = "\(data.forecast.forecastday[0].hour[1].temp_str) C"
            self.iconTempPredTwo.image = UIImage(named: data.forecast.forecastday[0].hour[1].condition.icon)
            self.timePredTwo.text = data.forecast.forecastday[0].hour[1].time
            
            // change data 3 jam kedepan
            self.tempPredThree.text = "\(data.forecast.forecastday[0].hour[2].temp_str) C"
            self.iconTempPredThree.image = UIImage(named: data.forecast.forecastday[0].hour[2].condition.icon)
            self.timePredThree.text = data.forecast.forecastday[0].hour[2].time
        }
    }
    
    func failedUpdateUI(_ error: Error) {
        print(error)
    }
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let long = location.coordinate.longitude
            let lat = location.coordinate.latitude
            apiManager.getDataFromLiveLocation(lat, long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}







