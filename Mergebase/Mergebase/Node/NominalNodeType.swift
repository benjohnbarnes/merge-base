//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


/*
 I'm not sure the approach used here is right.
 
 It fits nicely with `Node` having a method `conforms(to:)`.
 
 A better design might be for `NominalNodeType` to just be an id. This would require conformance checking of
 `Node` to `NodeType` to be implemented by something that knows the actual `NodeType` associated with a
 `NominalNodeId`.
 */

public class NominalNodeType: Hashable, Codable {
    
    public init(type: NodeType) {
        self.type = type
    }
    
    public static func == (lhs: NominalNodeType, rhs: NominalNodeType) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
    
    let type: NodeType
}

