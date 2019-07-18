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
        fatalError()
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
