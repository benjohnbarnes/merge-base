//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

class StoreMorphism<Key:Hashable, Value>: Morphism {

    var keys: Set<Key> {
        return Set(store.keys)
    }
    
    subscript(key: Key) -> Value? {
        get {
            return store[key]
        }
        
        set {
            store[key] = newValue
        }
    }
    
    private var store: [Key: Value] = [:]
}

