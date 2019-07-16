//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Swift

protocol Arrow {
    associatedtype Key: Hashable
    associatedtype Value

    // The deal is that an arrow can be partial, in which case it will only give a value for its keys. Or it can be
    // total, in which case it's key set is the whole Key domain, and it will always provide value.
    var keys: Set<Key> {get}
    subscript(_ key: Key) -> Value? {get}
}

