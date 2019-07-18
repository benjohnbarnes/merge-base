//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public indirect enum Node: Hashable {
    case unit
    
    case bool(Bool)
    case number(Double)
    case string(String)
    case data(Data)
    case identifier(Unique)

    case tuple([Node])
    case set(Set<Node>)
    case array([Node])

    case variant(VariantName, Node)
}

public struct Unique: Hashable {
    public init() {}
    private let identifier = UUID()
}

public typealias VariantName = String

public struct NodeArrowType {
    let keyType: NodeType
    let valueType: NodeType
}

