//
//  TargetType.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Task {
    
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding = JSONEncoding.default)
}

protocol TargetType {
        
    var path: String {get}
    
    var method: HTTPMethod {get}
    
    var task: Task {get}
    
    var headers: [String: String]? {get}
}
