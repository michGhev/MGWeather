//
//  NetworkResponse.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Alamofire

// MARK: - Codable operator decode and encode
infix operator <~: AdditionPrecedence
infix operator ~>: AdditionPrecedence
infix operator <!: AdditionPrecedence
internal func <~<A: Decodable, K>(property: inout A, mapping: (KeyedDecodingContainer<K>, K)) {
  do {
    if let val = try mapping.0.decodeIfPresent(A.self, forKey: mapping.1) {
      property = val
    }
  } catch {}
}

internal func ~><A: Encodable, K>(container: inout KeyedEncodingContainer<K>, mapping: (A, K)) {
  do {
    try container.encode(mapping.0, forKey: mapping.1)
  } catch {}
}

internal func <!<A: Decodable, K>(container: KeyedDecodingContainer<K>, key: K) -> A {
  return try! container.decode(A.self, forKey: key)
}

public enum NetworkResponse<T> {
    case next(value: T, statusCode: Int)
    case error(error: NetworkError, statusCode: Int)

    public var isNext: Bool {
        if case .next = self {
            return true
        }
        return false
    }

    public var value: T? {
        switch self {
        case .next(value: let val, statusCode: _):
            return val
        default: return nil
        }
    }

    public var statusCode: Int {
        switch self {
        case .next(value: _, statusCode: let code):
            return code
        case .error(error: _, statusCode: let code):
            return code
        }
    }

    public func toVoid() -> NetworkResponseVoid {
        switch self {
        case .error(error: let error, statusCode: let code):
            return .error(error: error, statusCode: code)
        case .next(value: _, statusCode: let code):
            return .next(statusCode: code)
        }
    }
}

public enum NetworkResponseVoid {
    case next(statusCode: Int)
    case error(error: NetworkError, statusCode: Int)

    public var isNext: Bool {
        if case .next(_) = self {
            return true
        }
        return false
    }
}


public struct NetworkError: Error, Decodable {
    public var code: Int? = 400
    public var message: String?
    public var errors: [ErrorKey: String]?
    public var status: String?

    public init(code: Int, message: String? = nil, errors: [ErrorKey: String]? = nil) {
        self.code = code
        self.message = message
        self.errors = errors
    }

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case errors = "errors"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message <~ (values, .message)
        errors <~ (values, .errors)
        status <~ (values, .status)
    }

    public init(withAFError: AFError) {

            if let underlyingError = withAFError.underlyingError as NSError?,
               [NSURLErrorNotConnectedToInternet, NSURLErrorDataNotAllowed].contains(underlyingError.code) {
                self.message = "Texts.General.noInternetConnection"
            } else if withAFError.isExplicitlyCancelledError ||
                        withAFError.isSessionTaskError {
                self.message = "Request explicitly cancelled"
            }


    }

    public init(withError: Error) {
        self.message = withError.asAFError.debugDescription

    }

    public var localizedDescription: String {
        return message ?? ""
    }
}

extension NetworkError {
    public func toNSError() -> NSError {
        return .init(domain: Bundle.main.bundleIdentifier ?? "Application", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

extension NSError {
    public func toNetworkError() -> NetworkError {
        return NetworkError(code: self.code, message: self.localizedDescription)
    }
}

public typealias ErrorKey = String
