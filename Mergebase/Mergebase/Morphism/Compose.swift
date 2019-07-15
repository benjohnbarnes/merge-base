//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

func compose<M1: Morphism, M2: Morphism>(_ m1: M1, _ m2: M2) -> MorphismComposition<M1, M2> where M2.Key == M1.Value {
    return MorphismComposition(m1, m2)
}

struct MorphismComposition<M1: Morphism, M2: Morphism>: Morphism where M2.Key == M1.Value {
    
    init(_ m1: M1, _ m2: M2) {
        self.m1 = m1
        self.m2 = m2
    }
    
    var keys: Set<M1.Key> {
        let m2Keys = m2.keys
        return m1.keys.filter { m2Keys.contains(m1[$0]!) }
    }
    
    subscript(key: M1.Key) -> M2.Value? {
        guard let k2 = m1[key] else { return nil }
        return m2[k2]
    }
    
    typealias Key = M1.Key
    typealias Value = M2.Value
    
    let m1: M1
    let m2: M2
}
