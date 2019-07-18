//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


extension NodeType: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeDetail<T: Decodable>() throws -> T {
            return try container.decode(T.self, forKey: .detail)
        }
        
        func decodeRange<R: Decodable>() throws -> R {
            return try container.decode(R.self, forKey: .range)
        }
        
        let kind = try container.decode(Case.self, forKey: .case)
        
        switch kind {
            
        case .anything:
            self = .anything
            
        case .nominal:
            self = .nominal(try decodeDetail())
            
        case .bool:
            self = .bool
            
        case .identifier:
            self = .identifier
            
        case .type:
            self = .type
            
        case .number:
            self = .number(try decodeRange())
            
        case .string:
            self = .string(try decodeRange())
            
        case .data:
            self = .data(try decodeRange())
            
        case .tuple:
            self = .tuple(try decodeDetail())
            
        case .variant:
            self = .variant(try decodeDetail())
            
        case .set:
            self = .set(try decodeDetail(), try decodeRange())
            
        case .array:
            self = .array(try decodeDetail(), try decodeRange())
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .anything:
            try container.encode(Case.anything, forKey: .case)

        case let .nominal(detail):
            try container.encode(Case.nominal, forKey: .case)
            try container.encode(detail, forKey: .detail)

        case .bool:
            try container.encode(Case.bool, forKey: .case)

        case .identifier:
            try container.encode(Case.identifier, forKey: .case)

        case .type:
            try container.encode(Case.type, forKey: .case)

        case let .number(range):
            try container.encode(Case.number, forKey: .case)
            try container.encode(range, forKey: .range)

        case let .string(range):
            try container.encode(Case.string, forKey: .case)
            try container.encode(range, forKey: .range)

        case let .data(range):
            try container.encode(Case.data, forKey: .case)
            try container.encode(range, forKey: .range)

        case let .tuple(detail):
            try container.encode(Case.tuple, forKey: .case)
            try container.encode(detail, forKey: .detail)

        case let .variant(detail):
            try container.encode(Case.variant, forKey: .case)
            try container.encode(detail, forKey: .detail)

        case let .set(detail, range):
            try container.encode(Case.set, forKey: .case)
            try container.encode(detail, forKey: .detail)
            try container.encode(range, forKey: .range)

        case let .array(detail, range):
            try container.encode(Case.array, forKey: .case)
            try container.encode(detail, forKey: .detail)
            try container.encode(range, forKey: .range)
        }
    }
        
    private enum Case: String, Codable {
        case anything = "any"
        case nominal = "nom"
        case bool = "boo"
        case identifier = "id"
        case type = "typ"
        case number = "num"
        case string = "str"
        case data = "dat"
        case tuple = "tup"
        case variant = "var"
        case set = "set"
        case array = "arr"
    }
    
    private enum CodingKeys: String, CodingKey {
        case `case` = "c"
        case detail = "d"
        case range = "r"
    }
}
