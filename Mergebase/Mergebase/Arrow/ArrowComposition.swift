//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift


extension Arrow {
    
    func compose<A: Arrow>(_ other: A) -> ArrowComposition<Self, A> where Key == A.Value {
        return ArrowComposition(self, other)
    }
}

struct ArrowComposition<M1: Arrow, M2: Arrow>: Arrow where M2.Key == M1.Value {
    
    init(_ m1: M1, _ m2: M2) {
        self.m1 = m1
        self.m2 = m2
    }
    
    func records() -> [M1.Key : M2.Value] {
        let r1 = m1.records()
        let r2 = m2.records()

        return r1.compactMapValues { r2[$0] }
    }
    
    let m1: M1
    let m2: M2
}
