//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Arrow {
    func intersection<Other: Arrow>(_ other: Other) -> ArrowIntersection2<Self, Other> where Key == Other.Key {
        return ArrowIntersection2(m1: self, m2: other)
    }
}

struct ArrowIntersection2<M1: Arrow, M2: Arrow>: Arrow where M1.Key == M2.Key {
    
    func records() -> [Key: Value] {
        let r1 = m1.records()
        let r2 = m2.records()
        
        let commonKeys = Set(r1.keys).intersection(r2.keys)
        
        let keysAndValues = commonKeys.map{
            key in
            return (key, Value(v1: r1[key]!, v2: r2[key]!))
        }
        
        return Dictionary(uniqueKeysWithValues: keysAndValues)
    }

    typealias Key = M1.Key
    
    struct Value {
        let v1: M1.Value
        let v2: M2.Value
    }
    
    let m1: M1
    let m2: M2
}
