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
        fatalError()
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
