//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Arrow {
    func select(keysHaving predicate: @escaping (Key) -> Bool) -> ArrowKeySelect<Self> {
        return ArrowKeySelect(underlying: self, predicate: predicate)
    }
}

struct ArrowKeySelect<Underlying: Arrow>: Arrow {
    
    var keys: Set<Underlying.Key> {
        return underlying.keys.filter(predicate)
    }
    
    subscript(key: Underlying.Key) -> Underlying.Value? {
        guard predicate(key) else { return nil }
        return underlying[key]
    }
    
    typealias Key = Underlying.Key
    typealias Value = Underlying.Value

    let underlying: Underlying
    let predicate: (Underlying.Key) -> Bool
}

