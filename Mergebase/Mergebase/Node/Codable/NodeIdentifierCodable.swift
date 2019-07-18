//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

extension NodeIdentifier: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decode<T: Decodable>(forKey key: CodingKeys) throws -> T {
            return try container.decode(T.self, forKey: key)
        }
        
        let `case`: Case = try decode(forKey: .case)
        
        switch `case` {
        case .uuid: self = .uuid(try decode(forKey: .value))
        case .string: self = .string(try decode(forKey: .value))
        case .url: self = .url(try decode(forKey: .value))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .uuid(value):
            try container.encode(Case.uuid, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .string(value):
            try container.encode(Case.string, forKey: .case)
            try container.encode(value, forKey: .value)

        case let .url(value):
            try container.encode(Case.url, forKey: .case)
            try container.encode(value, forKey: .value)

        }
    }
    
    private enum Case: String, Codable {
        case uuid
        case string
        case url
    }
    
    private enum CodingKeys: String, CodingKey {
        case `case` = "c"
        case value = "v"
    }
}
