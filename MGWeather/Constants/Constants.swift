//
//  Constants.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation
import UIKit

struct Constants {
    static var responseDefaultKeyPath: String = "data"
}

enum GlobalRepoParams {
    
    case baseCountriesURL
    case baseWeatherURL
    
    var value: String {
        switch self {
        case .baseCountriesURL: return "https://countriesnow.space/api/v0.1/countries"
        case .baseWeatherURL: return "https://api.openweathermap.org/data/2.5/weather?"
        }
    }
}

class BaseUrl {
    static let shared = BaseUrl()
    var baseUrl: BaseURlType
    
    init(baseUrl: BaseURlType = .baseCountriesUrl) {
        self.baseUrl = baseUrl
    }
}

enum BaseURlType {
    case baseCountriesUrl
    case baseWeatherUrl

}
