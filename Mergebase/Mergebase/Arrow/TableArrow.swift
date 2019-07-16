//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

class TableArrow<Key: Hashable, Value>: Arrow {

    func records() -> [Key : Value] {
        return values
    }
    
    subscript(_ key: Key) -> Value? {
        get {
            return values[key]
        }
        
        set {
            values[key] = newValue
        }
    }
    
    var values: [Key: Value] = [:]
}


