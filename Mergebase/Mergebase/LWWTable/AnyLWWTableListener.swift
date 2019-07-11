//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

struct AnyLWWTableListener<Key: Hashable, Value, Time: Hashable & Comparable>: LWWTableListening {
    
    init<Lisener: LWWTableListening>(_ listener: Lisener) where Lisener.Key == Key, Lisener.Value == Value, Lisener.Time == Time {
        _handleInsert = listener.handleInsert
        _handleChange = listener.handleChange
    }
    
    func handleInsert(key: Key, value: Value?, time: Time) {
        _handleInsert(key, value, time)
    }
    
    func handleChange(key: Key, oldValue: Value?, newValue: Value?, oldTime: Time, newTime: Time) {
        _handleChange(key, oldValue, newValue, oldTime, newTime)
    }
    

    private let _handleInsert: (Key, Value?, Time) -> Void
    private let _handleChange: (Key, Value?, Value?, Time, Time) -> Void
}

