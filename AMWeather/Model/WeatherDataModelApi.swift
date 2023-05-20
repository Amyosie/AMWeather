//
//  WeatherDataModelApi.swift
//  AMWeather
//
//  Created by Yosie Abdul Muzanil on 15/05/23.
//

import UIKit

// Main Data Weather

class WeatherDataModelApi:Codable{
    let location : Location
    let current : Current
    let forecast : Forecast
}

// Location

struct Location : Codable {
    let name : String
    let country : String
    let lat : Float
    let lon : Float
    let localtime : String
}

// Current

struct Current : Codable {
    let temp_c : Float
    var temp_str : String {
        return String(format: "%0.f", temp_c)
    }
    let condition : Condition
    let wind_mph : Float
    let wind_kph : Float
}

// condition

class Condition : Codable {
    let text : String
    let code : Int
    var icon : String
    
    var timeCondition : String {
        if icon.contains("day") {
            return "day"
        }else {
            return "night"
        }
    }
}

// Forecast

struct Forecast : Codable {
    let forecastday : [DayForecast]
}

// detail forecast per day

class DayForecast : Codable {
    let date : String
    var hour : [Hour]
}

// detail forecast per hour

class Hour : Codable {
    var time : String
    
    let temp_c : Float
    var temp_str : String {
        return String(format: "%0.f", temp_c)
    }
    let condition : Condition
    let wind_mph : Float
    let wind_kph : Float
}
