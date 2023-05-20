protocol WeatherProtocol {
    func updateUI(_ data:WeatherDataModelApi)
    func failedUpdateUI(_ error:Error)
}
