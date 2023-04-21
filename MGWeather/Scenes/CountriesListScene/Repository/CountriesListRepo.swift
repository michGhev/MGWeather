//
//  CountriesListRepo.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//


import UIKit

enum CountriesListTargetType: TargetType {
    case getCountriesList
    
    var baseURL: String {
        switch self {
        default:
            return GlobalRepoParams.baseCountriesURL.value
        }
    }
    
    var path: String {
        switch self {
        case .getCountriesList:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCountriesList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getCountriesList:
            return .requestParameters(parameters: [:])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}

class CountriesListRepo: BaseRepository<CountriesListTargetType> {
    func getCountriesList(completionHandler: @escaping (CountryResponseModel?, NetworkError?) -> Void) {
        return fetchData(target: .getCountriesList, responseClass: CountryResponseModel.self) { (result) in
            switch result {
            case .success(let countryListData):
                completionHandler(countryListData, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}



