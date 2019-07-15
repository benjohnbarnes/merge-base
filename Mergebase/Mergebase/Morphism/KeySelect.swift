//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Morphism {
    func select(keysHaving predicate: @escaping (Key) -> Bool) -> MorphismKeySelect<Self> {
        return MorphismKeySelect(underlying: self, predicate: predicate)
    }
}

struct MorphismKeySelect<Underlying: Morphism>: Morphism {
    
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

