//
//  BaseRepository.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Alamofire
import SwiftyJSON

class BaseRepository<T: TargetType> {
    
    var baseURL: String {
        switch BaseUrl.shared.baseUrl {
        case .baseCountriesUrl:
            return GlobalRepoParams.baseCountriesURL.value
        case .baseWeatherUrl:
            return GlobalRepoParams.baseWeatherURL.value
        }
    }
        
     var sessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    func fetchPlainData(target: T, completionHandler: @escaping (NetworkError?) -> Void) {

        let url = baseURL + target.path
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let parameters = buildParams(task: target.task)

        self.printRequestDetails(url, headers, method, parameters)
        AF.request(url,
                   method: method,
                   parameters: parameters.0,
                   encoding: URLEncoding.default,
                   headers: headers).response { (responseObject) in
            if let safeResponseObj = responseObject.response,
               safeResponseObj.statusCode != 200 {
                self.printResponseObject(responseObject.response)
            }
            if let safeResponseObjData = responseObject.data {
                var responseAsADict: [String: Any] = [:]
                self.convertResponseToDictionary(safeResponseObjData) { (result, error) in
                    if error != nil {
                        print("🆘🆘🆘🆘 Could not convert data to Dictionary: ", error)
                    } else if let result = result {
                        responseAsADict = result
                    } else {
                    }
                }
                if self.isStatusFieldContainsError(responseAsADict,
                                       statusCode: responseObject.response?.statusCode) {
                    do {
                        if let responseObj = try CodableService().decodeObject(of: NetworkError.self,
                                                                               data: safeResponseObjData) {
                            completionHandler(responseObj)
                        } else {
                            print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
                        }
                    } catch {
                        print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
                        completionHandler(NetworkError.init(withError: error))
                    }
                    return
                }
            }
            if let safeError = responseObject.error {
                completionHandler(NetworkError.init(withAFError: safeError))
            } else {
                completionHandler(nil)
            }
        }
    }

    func fetchData<M: Decodable>(target: T,
                                 responseClass: M.Type,
                                 encoding: URLEncoding = .default,
                                 completionHandler: @escaping (Result<M, NetworkError>) -> Void) {

        let url = baseURL + target.path
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let parameters = buildParams(task: target.task)

        self.printRequestDetails(url, headers, method, parameters)

        AF.request(url,
                   method: method,
                   parameters: parameters.0,
                   encoding: encoding,
                   headers: headers).response { (responseObject) in
          
            if let safeResponseObj = responseObject.response,
               safeResponseObj.statusCode != 200 {
                self.printResponseObject(responseObject.response)
                completionHandler(.failure(NetworkError(code: safeResponseObj.statusCode,
                                                        message: safeResponseObj.url?.absoluteString)))
            } else {
                if responseObject.error != nil {
                } else {
                    if let safeResponseObjData = responseObject.data {
                        var responseAsADict: [String: Any] = [:]
                        self.convertResponseToDictionary(safeResponseObjData) { (result, error) in
                            if error != nil {
                                print("🆘🆘🆘🆘 Could not convert data to Dictionary: ", error ?? "Error is nil")
                            } else if let result = result {
                                responseAsADict = result
                            } else {
                            }
                        }
                        if self.isStatusFieldContainsError(responseAsADict,
                                               statusCode: responseObject.response?.statusCode) {
                            do {
                                if let responseObj = try CodableService().decodeObject(of: NetworkError.self,
                                                                                       data: safeResponseObjData) {
                                    completionHandler(.failure(responseObj))
                                } else {
                                    print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
                                }
                            } catch {
                                print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
                                completionHandler(.failure(NetworkError.init(withError: error)))
                            }

                        } else {
                            do {
                                let recentStickers = try JSONDecoder().decode(M.self, from: safeResponseObjData)
                                completionHandler(.success(recentStickers))
                            } catch {
                                print(error.localizedDescription.debugDescription)
                                print(error.localizedDescription.description)

                                completionHandler(.failure(NetworkError.init(withError: error)))
                            }
                        }
                    } else {
                        completionHandler(.failure(NetworkError.init(code: 400,
                                                                     message: "Response object as a data is Nil")))
                    }
                }
            }
        }
    }

    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }

    private func printRequestDetails(_ url: String,
                                     _ headers: HTTPHeaders,
                                     _ method: Alamofire.HTTPMethod,
                                     _ parameters: ([String: Any], ParameterEncoding)) {
        print("➡️➡️➡️➡️➡️➡️➡️ Request start ➡️➡️➡️➡️➡️➡️➡️")
        print("➡️ URL: ", url)
        print("➡️ METHOD: ", method.rawValue)
        print("➡️ HEADERS: ", headers)
        print("➡️ PARAMS: ", parameters.0)
    }

    private func convertResponseToDictionary(_ responseObjectData: Data,
                                             completionHandler: @escaping ([String: Any]?, NSError?) -> Void) {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: responseObjectData, options: []) as? [String: Any]
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("✅✅✅✅✅✅✅ Response start ✅✅✅✅✅✅✅")
                print("✅ DATA: ", jsonString)

            }
            completionHandler(jsonDict, nil)
        } catch {
            print("🐸  JSON parse error: ", error)
            completionHandler(nil, NSError(domain: "JSON error parse", code: 1, userInfo: nil))
        }
    }

    private func printResponseObject(_ responseObj: HTTPURLResponse?) {
        print("👹👹👹👹👹👹👹 Response fail 👹👹👹👹👹👹👹")
        print("👹 ResponseObject: ", responseObj ?? "Object is nil")
        print("👹 StatusCode: ", responseObj?.statusCode ?? "Object is nil")
        print("👹 Content-Type: ", responseObj?.headers.value(for: "Content-Type") ?? "Object is nil")
    }

    private func printResponseDetails(_ responseObjectDict: [String: Any]) {
            print("✅✅✅✅✅✅✅ Response start ✅✅✅✅✅✅✅")
            print("✅ DATA: ", responseObjectDict)

    }

    private func isStatusFieldContainsError(_ result: [String: Any], statusCode: Int?) -> Bool {
        if let statusCode = statusCode,
           statusCode != 200 {

            let containsError = result.contains { (key: String, value: Any) in
                let valueStr = value as? String
                return key == "status" && (valueStr == "ERROR" ||
                                           valueStr == "INVALID_DATA" ||
                                           valueStr == "NOT_FOUND" ||
                                           valueStr == "TOKEN_MISMATCH" ||
                                           valueStr == "UNAUTHORIZED" ||
                                           valueStr == "FORBIDDEN" ||
                                           valueStr == "APP_ERROR")
            }
            return containsError
        }
        return false
    }
}
