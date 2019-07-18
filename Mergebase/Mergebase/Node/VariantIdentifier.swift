//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


public struct VariantIdentifier: Hashable, Codable {
    
    public init() {
        identifier = NodeIdentifier()
    }
    
    public init(_ identifier: NodeIdentifier) {
        self.identifier = identifier
    }
    
    public let identifier: NodeIdentifier
}

