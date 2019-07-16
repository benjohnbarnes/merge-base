//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift


extension Arrow {

    func map<Value2>(_ t: @escaping (Value) -> Value2) -> ArrowMap<Self, Value2> {
        return ArrowMap(underlying: self, t: t)
    }
}

struct ArrowMap<Underlying: Arrow, Value>: Arrow {
    
    func records() -> [Underlying.Key : Value] {
        return underlying.records().mapValues(t)
    }

    fileprivate let underlying: Underlying
    fileprivate let t: (Underlying.Value) -> Value
}

