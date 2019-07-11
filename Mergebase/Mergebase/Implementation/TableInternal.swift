//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


class InternalTable {
    
    init() {}

    var keys: Set<Node> {
        return Set(
            store.compactMap {
                guard $0.value.binding != nil else { return nil }
                return $0.key
        })
    }

    func get(key: Node) -> Node? {
        return store[key]?.binding
    }

    func performSet(change: ChangeId, key: Node, value: Node?) {
        if let backing = store[key], backing.clock > change {
            return
        }
        
        store[key] = ValueBacking(clock: change, binding: value)
    }
    
    var store: [Node: ValueBacking] = [:]
    
    struct ValueBacking {
        var clock: ChangeId
        var binding: Node?
    }
}
