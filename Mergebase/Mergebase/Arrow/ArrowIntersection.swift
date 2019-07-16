//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

func intersection<M1: Arrow, M2: Arrow>(_ m1: M1, _ m2: M2) -> ArrowIntersection2<M1, M2> where M1.Key == M2.Key {
    return ArrowIntersection2(m1: m1, m2: m2)
}

struct ArrowIntersection2<M1: Arrow, M2: Arrow>: Arrow where M1.Key == M2.Key {
    
    var keys: Set<Key> {
        return m1.keys.intersection(m2.keys)
    }
    
    subscript(key: Key) -> Value? {
        guard let v1 = m1[key], let v2 = m2[key] else { return nil }
        return Value(v1: v1, v2: v2)
    }
    
    typealias Key = M1.Key

    struct Value {
        let v1: M1.Value
        let v2: M2.Value
    }
    
    let m1: M1
    let m2: M2
}
