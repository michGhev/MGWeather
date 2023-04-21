//
//  CountryModel.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation
import RealmSwift

struct CountryResponseModel: Codable, SnakeCaseStrategable {
    var countryData: [CountryModel]
    
    enum CodingKeys: String, CodingKey {
        case countryData = "data"
    }
}


struct CountryModel: Codable, SnakeCaseStrategable {
    var country: String
    var cities: [String]
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case cities = "cities"
    }
}

class CountryModelRealm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var country: String
    @Persisted var cities = List<String>()
}

