//
//  WeatherModels.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation

enum WeatherRequestParams: String {
    case cityName = "q"
    case api = "appid"
}

struct WeatherModel: Codable, SnakeCaseStrategable {
    var main: Main
    var coord: Coord
    var name: String
    var visibility: Int
    var sys: Sys
    var weather: [Weather]
    var wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
        case coord = "coord"
        case name = "name"
        case sys = "sys"
        case weather = "weather"
        case visibility = "visibility"
        case wind = "wind"
    }
}

struct Main: Codable, SnakeCaseStrategable {
    var temp: Double
    var tempMin: Double
    var tempMax: Double
    var humidity: Double
    var feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case humidity = "humidity"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
    }
}

struct Coord: Codable, SnakeCaseStrategable {
    var lon: Double
    var lat: Double
    
    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
}

struct Sys: Codable, SnakeCaseStrategable {
    var country: String
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
    }
}

struct Weather: Codable, SnakeCaseStrategable {
    var main: String
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
    }
}

struct Wind: Codable, SnakeCaseStrategable {
    var speed: Double
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
    }
}


enum WeatherMain: String {
    case Clouds  = "Clouds"
    case Drizzle = "Drizzle"
    case Clear   = "Clear"
    case Rain    = "Rain"
}
