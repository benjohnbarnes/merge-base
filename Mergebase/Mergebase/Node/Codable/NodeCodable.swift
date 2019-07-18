//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

extension Node: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decode<T: Decodable>(forKey key: CodingKeys) throws -> T {
            return try container.decode(T.self, forKey: key)
        }

        func decodeValue<T: Decodable>() throws -> T {
            return try container.decode(T.self, forKey: .value)
        }
        
        let nodeKind: Case = try decode(forKey: .case)
        
        switch nodeKind {
        case .bool:
            self = .bool(try decodeValue())
            
        case .identifier:
            self = .identifier(try decodeValue())
            
        case .number:
            self = .number(try decodeValue())
            
        case .string:
            self = .string(try decodeValue())
            
        case .data:
            self = .data(try decodeValue())
            
        case .type:
            self = .type(try decodeValue())
            
        case .tuple:
            self = .tuple(try decodeValue())
            
        case .variant:
            self = .variant(try decode(forKey: .variant), try decodeValue())
            
        case .set:
            self = .set(try decodeValue())
            
        case .array:
            self = .array(try decodeValue())
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .bool(value):
            try container.encode(Case.bool, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .identifier(value):
            try container.encode(Case.identifier, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .number(value):
            try container.encode(Case.number, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .string(value):
            try container.encode(Case.string, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .data(value):
            try container.encode(Case.data, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .type(value):
            try container.encode(Case.type, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .tuple(value):
            try container.encode(Case.tuple, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .variant(variant, value):
            try container.encode(Case.variant, forKey: .case)
            try container.encode(variant, forKey: .variant)
            try container.encode(value, forKey: .value)

        case let .set(value):
            try container.encode(Case.set, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .array(value):
            try container.encode(Case.array, forKey: .case)
            try container.encode(value, forKey: .value)
        }
    }

    private enum Case: String, Codable {
        case bool = "b"
        case identifier = "i"
        
        case number = "n"
        case string = "s"
        case data = "d"
        case type = "ty"
        
        case tuple = "t"
        case variant = "v"
        
        case set = "st"
        case array = "ar"
    }
    
    private enum CodingKeys: String, CodingKey {
        case `case` = "c"
        case value = "v"
        case variant = "var"
    }
    
}
