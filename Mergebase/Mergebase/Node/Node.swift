//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public indirect enum Node: Hashable {

    // Scalars
    //
    case bool(Bool)
    case number(Double)
    case string(String)
    case data(Data)

    // First class Type.
    //
    case type(NodeType)
    
    // Some identified thing in the system.
    //
    case identifier(NodeIdentifier)

    // Product and Sum types.
    //
    case tuple([Node])
    case variant(VariantIdentifier, Node)

    // Collections.
    //
    case set(Set<Node>)
    case array([Node])
}

