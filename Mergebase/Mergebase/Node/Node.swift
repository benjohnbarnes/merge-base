//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public indirect enum Node: Hashable {
    case bool(Bool)
    case identifier(NodeIdentifier)

    case number(Double)
    case string(String)
    case data(Data)
    case type(NodeType)

    case tuple([Node])
    case variant(VariantIdentifier, Node)

    case set(Set<Node>)
    case array([Node])
}

