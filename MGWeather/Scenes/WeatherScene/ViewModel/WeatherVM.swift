//
//  WeatherVM.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation

class WeatherVM: BaseVM {
    
    // MARK: - Private properties
    
    private var weatherRepo: WeatherRepo = WeatherRepo()
    private var city: String?

    // MARK: - Functions
    
    func setCity(_ city: String) {
        self.city = city
    }
    
    func getWeather() {
        guard let city = self.city else { return }
        self.checkInternet()
        ActivityIndicatorView.shared.startAnimating()
        weatherRepo.getWeather(city: city) { weatherData, error in
            if error == nil {
                guard let result = weatherData else { return }
                self.baseDelegate?.dataFetched(type: WeatherModel.self, data: result, observerName: "")
            } else if let error = error {
                if let safeErrors = error.errors {
                    self.baseDelegate?.invalidDataErrorReceived(fieldType: WeatherRequestParams.self, data: safeErrors)
                } else {
                    self.baseDelegate?.errorReceived(error: error)
                }
            }
        }
    }
}
