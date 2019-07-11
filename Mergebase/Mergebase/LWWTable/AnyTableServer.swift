//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

protocol TableServing {
    associatedtype Key: Hashable
    associatedtype Value
    
    func get(key: Key) -> Value?
    func set(key: Key, value: Value?)
}

extension TableServing {
    subscript(_ key: Key) -> Value? {
        get {
            return get(key: key)
        }
        
        set {
            set(key: key, value: newValue)
        }
    }
}

struct AnyTableServer<Key: Hashable, Value>: TableServing {

    init<Server: TableServing>(_ server: Server) where Server.Key == Key, Server.Value == Value {
        _set = server.set
        _get = server.get
    }
    
    func get(key: Key) -> Value? {
        return _get(key)
    }

    func set(key: Key, value: Value?) {
        _set(key, value)
    }

    private let _get: (Key) -> Value?
    private let _set: (Key, Value?) -> Void
}

