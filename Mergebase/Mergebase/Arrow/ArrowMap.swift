//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift


extension Arrow {

    func mapKey<U>(_ t: @escaping (Key) -> U) -> ArrowMap<Self, U> {
        return mapKeyValue { key, _ in t(key)}
    }
    
    func mapValue<U>(_ t: @escaping (Value) -> U) -> ArrowMap<Self, U> {
        return mapKeyValue { _, value in t(value)}
    }

    func mapKeyValue<U>(_ t: @escaping (Key, Value) -> U) -> ArrowMap<Self, U> {
        return ArrowMap(underlying: self, t: t)
    }
}

struct ArrowMap<Underlying: Arrow, Value>: Arrow {
    
    func records() -> [Underlying.Key : Value] {
        return Dictionary(uniqueKeysWithValues: underlying.records().map {
            keyValue in
            return (keyValue.key, t(keyValue.key, keyValue.value))
        })
    }
    
    fileprivate let underlying: Underlying
    fileprivate let t: (Underlying.Key, Underlying.Value) -> Value
}

