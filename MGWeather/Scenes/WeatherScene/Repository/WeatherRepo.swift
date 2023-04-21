//
//  WeatherRepo.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit

enum WeatherTargetType: TargetType {
    var baseURL: String {
        switch self {
        default:
            return GlobalRepoParams.baseWeatherURL.value
        }
    }
    
    case getWeather(city: String)
    
    var path: String {
        switch self {
        case .getWeather:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWeather:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getWeather(let city):
            return .requestParameters(parameters: [WeatherRequestParams.cityName.rawValue: city,
                                                   WeatherRequestParams.api.rawValue: "0635262e5eebbe39a21ad25905a30c9d"])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}

class WeatherRepo: BaseRepository<WeatherTargetType> {
    func getWeather(city: String, completionHandler: @escaping (WeatherModel?, NetworkError?) -> Void) {
        return fetchData(target: .getWeather(city: city), responseClass: WeatherModel.self) { (result) in
            switch result {
            case .success(let weatherData):
                completionHandler(weatherData, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}



