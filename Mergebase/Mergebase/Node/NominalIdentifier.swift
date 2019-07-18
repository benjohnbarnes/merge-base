//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


public struct NominalIdentifier: Hashable {
    
    public init() {
        identifier = NodeIdentifier()
    }
    
    public init(_ identifier: NodeIdentifier) {
        self.identifier = identifier
    }
    
    public let identifier: NodeIdentifier
}

//MARK:-

extension NominalIdentifier: Codable {
    
    /*
     Replace coding to avoid default implementation creating a needless wrapper.
     */
    public init(from decoder: Decoder) throws {
        identifier = try NodeIdentifier(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try identifier.encode(to: encoder)
    }
}
