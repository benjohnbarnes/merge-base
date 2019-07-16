//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

func union<M1: Arrow, M2: Arrow>(_ m1: M1, _ m2: M2) -> ArrowUnion2<M1, M2> where M1.Key == M2.Key {
    return ArrowUnion2(m1: m1, m2: m2)
}

struct ArrowUnion2<M1: Arrow, M2: Arrow>: Arrow where M1.Key == M2.Key {
    
    func records() -> [Key : Value] {
        let r1 = m1.records()
        let r2 = m2.records()
        
        let unionKeys = Set(r1.keys).union(r2.keys)
        
        let keysAndValues = unionKeys.map{
            key in
            return (key, Value(v1: r1[key], v2: r2[key]))
        }
        
        return Dictionary(uniqueKeysWithValues: keysAndValues)

    }
    
    typealias Key = M1.Key
    
    struct Value {
        let v1: M1.Value?
        let v2: M2.Value?
    }
    
    let m1: M1
    let m2: M2
}
