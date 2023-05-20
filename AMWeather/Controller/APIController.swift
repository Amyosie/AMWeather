import UIKit
import CoreLocation

class APIController {
    let token = "f220ea5632a94f43910143044231805"
    let urlPath = "https://api.weatherapi.com/v1/forecast.json?days=2&aqi=no&alerts=no"
    var conditionType : [WeatherCondition]?
    var dataWeather : WeatherDataModelApi?
    
    let formatDate = DateFormatter()

    
    
    var delegate : WeatherProtocol?
    
    func getFullApiPath(_ city:String){
        let url = "\(urlPath)&key=\(token)&q=\(city)"
        let dataURLCondition = "https://www.weatherapi.com/docs/weather_conditions.json"
        getDataWeatherAPI(url)
        getConditionWeatherAPI(dataURLCondition)
    }
    
    func getDataFromLiveLocation(_ lat:CLLocationDegrees, _ long:CLLocationDegrees){
        let url = "\(urlPath)&key=\(token)&q=\(lat),\(long)"
        let dataURLCondition = "https://www.weatherapi.com/docs/weather_conditions.json"
        getDataWeatherAPI(url)
        getConditionWeatherAPI(dataURLCondition)
    }
    
    // data weather
    
    func getDataWeatherAPI(_ url:String) {
        if let uri = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: uri) {
                data, response, error in
                if let data = data {
                    let result = self.parsingAPI(data)
                    if let result = result {
                        if let conditionType = self.conditionType {
                            for index in conditionType.indices {
                                if result.current.condition.code == conditionType[index].code {
                                    let folder = result.current.condition.timeCondition
                                    result.current.condition.icon = "\(folder)/\( conditionType[index].icon)"
                                    let listForecaset = self.filterForecastArrya(result.location.localtime, result.forecast.forecastday)
                                    result.forecast.forecastday[0].hour = listForecaset
                                    self.delegate?.updateUI(result)
                                    break
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func filterForecastArrya(_ firstHour : String, _ data : [DayForecast]) -> [Hour] {
        var result = [Hour]()
        formatDate.dateFormat = "yyyy-MM-dd HH:mm"
        let formatTime = DateFormatter()
        formatTime.dateFormat = "hh:MM"
        let first_hour = self.formatDate.date(from: firstHour)!
        let last_hour  = first_hour + TimeInterval(10800)
        
        for days in data.indices {
            for hour_day in data[days].hour.indices {
                let targetHour = formatDate.date(from: data[days].hour[hour_day].time)!
                if targetHour > first_hour && targetHour < last_hour {
                    if let conditionType = conditionType {
                        for index in conditionType.indices {
                            if data[days].hour[hour_day].condition.code == conditionType[index].code {
                                let folder = data[days].hour[hour_day].condition.timeCondition
                                data[days].hour[hour_day].condition.icon = "\(folder)/\( conditionType[index].icon)"
                                data[days].hour[hour_day].time = formatTime.string(from: targetHour)
                            }
                        }
                    }
                    result.append(data[days].hour[hour_day])
                }
            }
        }
        return result
    }
    
    // data condition
    
    func getConditionWeatherAPI(_ url:String) {
        if let uri = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: uri) {
                data, response, error in
                if let resultAPI = data {
                    self.conditionType = self.parsingAPICondition(resultAPI)
                }
            }
            task.resume()
        }
    }
    
    // parsing API
    
    func parsingAPI(_ data : Data) -> WeatherDataModelApi? {
        let decode = JSONDecoder()
        do {
            let result = try decode.decode(WeatherDataModelApi.self, from: data)
            return result
        }catch {
            delegate?.failedUpdateUI(error)
            return nil
        }
    }
    
    func parsingAPICondition(_ data : Data) -> [WeatherCondition]? {
        let decode = JSONDecoder()
        do {
            let result = try decode.decode([WeatherCondition].self, from: data)
            return result
        }catch {
            print(error)
            return nil
        }
    }
    
}
