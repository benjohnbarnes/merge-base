//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Arrow {
    
    func whereKey(_ predicate: @escaping (Key) -> Bool) -> ArrowKeySelect<Self> {
        return ArrowKeySelect(underlying: self, predicate: predicate)
    }
}

struct ArrowKeySelect<Underlying: Arrow>: Arrow {
    
    func records() -> [Underlying.Key : Underlying.Value] {
        return underlying.records().filter { predicate($0.key) }
    }

    let underlying: Underlying
    let predicate: (Underlying.Key) -> Bool
}

