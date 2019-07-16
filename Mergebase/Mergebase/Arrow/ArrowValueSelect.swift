//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Arrow {
    
    func whereValue(_ predicate: @escaping (Value) -> Bool) -> ArrowValueSelect<Self> {
        return ArrowValueSelect(underlying: self, predicate: predicate)
    }
}

struct ArrowValueSelect<Underlying: Arrow>: Arrow {
    
    func records() -> [Underlying.Key : Underlying.Value] {
        return underlying.records().filter { predicate($0.value) }
    }
    
    fileprivate let underlying: Underlying
    fileprivate let predicate: (Underlying.Value) -> Bool
}

