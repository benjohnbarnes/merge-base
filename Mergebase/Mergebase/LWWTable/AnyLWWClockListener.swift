//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

struct AnyLWWClockListener<Time: Hashable & Comparable>: LWWClockListening {
    
    init<Lisener: LWWClockListening>(_ listener: Lisener) where Lisener.Time == Time {
        _handleInsert = listener.handleInsert
        _handleChange = listener.handleChange
    }
    
    func handleInsert(time: Time) {
        _handleInsert(time)
    }
    
    func handleChange(oldTime: Time, newTime: Time) {
        _handleChange(oldTime, newTime)
    }
    
    
    private let _handleInsert: (Time) -> Void
    private let _handleChange: (Time, Time) -> Void
}

