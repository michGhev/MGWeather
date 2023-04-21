//
//  CodableService.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation

class CodableService {
    
    func decodeObject<T>(of type: T.Type, data: Data, key: String? = nil) throws -> T? where T: Decodable {
        let decoder = JSONDecoder()
        guard let key = key else {
            return try decoder.decode(T.self, from: data)
        }
        decoder.userInfo[.decoderRootKey] = key
        return try decoder.decode(DecodableRoot<T>.self, from: data).value
    }
    
    func encode<T>(_ objects: [T], key: String? = nil) throws -> Data where T: Encodable {
        let encoder = JSONEncoder()
        guard let key = key else {
            return try encoder.encode(objects)
        }
        encoder.userInfo[.encoderRootKey] = key
        encoder.userInfo[.asCollection] = true
        return try encoder.encode(EncodableRoot(objects))
    }
    
    private class DecodableRoot<T>: Decodable where T: Decodable {
        
        var value: T?
        var values = [T]()
        
        private struct CodingKeys: CodingKey {
            var stringValue: String
            var intValue: Int?
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            init?(intValue: Int) {
                self.intValue = intValue
                stringValue = "\(intValue)"
            }
            static func key(named name: String) -> CodingKeys? {
                return CodingKeys(stringValue: name)
            }
        }
        
        init() {}
        
        required convenience init(from decoder: Decoder) throws {
            self.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard let keyName = decoder.userInfo[.decoderRootKey] as? String, let key = CodingKeys.key(named: keyName) else {
                throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [], debugDescription: "Cannot find value/key at root level."))
            }
            if let _ = decoder.userInfo[.asCollection] {
                values = try container.decode(Array<T>.self, forKey: key)
                return
            }
            value = try container.decode(T.self, forKey: key)
        }
    }
    
    private class EncodableRoot<T>: Encodable where T: Encodable {
        
        let values: [T]
        
        private struct CodingKeys: CodingKey {
            var stringValue: String
            var intValue: Int?
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            init?(intValue: Int) {
                self.intValue = intValue
                stringValue = "\(intValue)"
            }
            static func key(named name: String) -> CodingKeys? {
                return CodingKeys(stringValue: name)
            }
        }
        
        init(_ objects: [T]) {
            values = objects
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            guard let keyName = encoder.userInfo[.encoderRootKey] as? String, let key = CodingKeys.key(named: keyName) else {
                throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [],
                                                                                debugDescription: "Cannot find value/key at root level."))
            }
            if let _ = encoder.userInfo[.asCollection] {
                try container.encode(values, forKey: key)
                return
            }
            try container.encode(values.first!, forKey: key)
        }
    }
}


import Foundation

typealias SnakeCaseCodable = Codable & SnakeCaseStrategable

extension CodingUserInfoKey {
    static let decoderRootKey = CodingUserInfoKey(rawValue: "decoderRootKey")!
    static let encoderRootKey = CodingUserInfoKey(rawValue: "encoderRootKey")!
    static let asCollection = CodingUserInfoKey(rawValue: "asCollection")!
}


public protocol Strategable {
    static var decodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    static var encodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
}

public protocol SnakeCaseStrategable: Strategable {}
public extension SnakeCaseStrategable {
    static var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }

    static var encodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return .convertToSnakeCase
    }
}

public extension Strategable where Self: Decodable {
    static var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .useDefaultKeys
    }
}

public extension Strategable where Self: Encodable {
    static var encodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return .useDefaultKeys
    }
}

extension Array: Strategable where Element: Strategable {
    public static var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return Element.decodingStrategy
    }

    public static var encodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return Element.encodingStrategy
    }
}
