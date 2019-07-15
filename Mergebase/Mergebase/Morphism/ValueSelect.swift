//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Morphism {
    
    func select(valuesHaving predicate: @escaping (Value) -> Bool) -> MorphismValueSelect<Self> {
        return MorphismValueSelect(underlying: self, predicate: predicate)
    }
}

struct MorphismValueSelect<Underlying: Morphism>: Morphism {
    
    var keys: Set<Underlying.Key> {
        return underlying.keys.filter { predicate(underlying[$0]!) }
    }
    
    subscript(key: Underlying.Key) -> Underlying.Value? {
        guard
            let value = underlying[key],
            predicate(value)
            else { return nil }

        return value
    }
    
    typealias Key = Underlying.Key
    typealias Value = Underlying.Value
    
    fileprivate let underlying: Underlying
    fileprivate let predicate: (Underlying.Value) -> Bool
}

