//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

extension Arrow {
    func intersection<Other: Arrow>(_ other: Other) -> ArrowIntersection2<Self, Other> where Key == Other.Key {
        return ArrowIntersection2(a1: self, a2: other)
    }
}

struct ArrowIntersection2<A1: Arrow, A2: Arrow>: Arrow where A1.Key == A2.Key {
    
    func records() -> [Key: Value] {
        let r1 = a1.records()
        let r2 = a2.records()
        
        let commonKeys = Set(r1.keys).intersection(r2.keys)
        
        let keysAndValues = commonKeys.map{
            key in
            return (key, Value(v1: r1[key]!, v2: r2[key]!))
        }
        
        return Dictionary(uniqueKeysWithValues: keysAndValues)
    }

    typealias Key = A1.Key
    
    struct Value {
        let v1: A1.Value
        let v2: A2.Value
    }
    
    let a1: A1
    let a2: A2
}
