//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

public struct NodeTypeValidator {

    public init() {}
    
    public func validate(node: Node, conformsTo type: NodeType) -> Bool {
        return node.conforms(to: type)
    }
}
