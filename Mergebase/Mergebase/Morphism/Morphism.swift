//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

protocol Morphism {
    associatedtype Key: Hashable
    associatedtype Value
    
    var keys: Set<Key> {get}
    subscript(_ key: Key) -> Value? {get}
}

