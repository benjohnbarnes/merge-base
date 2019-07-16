//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Arrow {
    
    func whereKey(_ keyPredicate: @escaping (Key) -> Bool) -> ArrowSelect<Self> {
        return whereKeyValue { key, _ in keyPredicate(key) }
    }

    func whereValue(_ valuePredicate: @escaping (Value) -> Bool) -> ArrowSelect<Self> {
        return whereKeyValue { _, value in valuePredicate(value) }
    }
    
    func whereKeyValue(_ predicate: @escaping (Key, Value) -> Bool) -> ArrowSelect<Self> {
        return ArrowSelect(underlying: self, predicate: predicate)
    }
}

struct ArrowSelect<Underlying: Arrow>: Arrow {
    
    func records() -> [Underlying.Key : Underlying.Value] {
        return underlying.records().filter { predicate($0.key, $0.value) }
    }

    let underlying: Underlying
    let predicate: (Underlying.Key, Underlying.Value) -> Bool
}

