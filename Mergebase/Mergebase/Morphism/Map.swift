//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift


extension Morphism {

    func map<Value2>(_ t: @escaping (Value) -> Value2) -> MorphismMap<Self, Value2> {
        return MorphismMap(underlying: self, t: t)
    }
}

struct MorphismMap<Underlying: Morphism, Value>: Morphism {
    
    var keys: Set<Underlying.Key> {
        return underlying.keys
    }
    
    subscript(key: Underlying.Key) -> Value? {
        guard let value = underlying[key] else { return nil }
        return t(value)
    }
    
    typealias Key = Underlying.Key

    fileprivate let underlying: Underlying
    fileprivate let t: (Underlying.Value) -> Value
}

