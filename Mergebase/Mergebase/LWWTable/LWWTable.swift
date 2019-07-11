//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


/*
 The log is not a great way to store the present state. It's better to just … store the present state. Freezing
 this allows it to continue to merge when brought back.
 
 Synchronisation of peers is a matter of finding the symmetric difference between their sets of the clocks of the
 (current) "winning" writes ("clock set"), and exchange keys and values for these elements.
 
 An efficient way to find the symmetric clock set difference is to build a binary merkel (hash) tree of the
 clock set.
 
 * For a size n set of clocks, this needs 2n space.

 * The tree can be maintained efficiently, and possibly only updated on demand to amortise updates.

 * The tree's fixed hierarchical structure means there is a known "address space" among all clients.

 * The tree should maintain the cardonality of the sets to help provide huristics for how best to sync that
 node. Possibly the size of data could be maintained too.
 
   * When counts / data are similar and large, recursion is addvisable to hopefully further bracket the exchange.
   * If either count / data is under some threshold, the full exchange is probably efficient.
 
 NB – It _is_ important for the set to respect the site part of the clocks, as well as the logical time. The same time
 can exist for multiple writes, and this is likely to happen. It's probably sufficient to leave the site out of the
 address scheme though – during an exchange, _all_ elements with that range of logical clock times would be exchanged,
 regardless of their site.

 A mechanism to make this work might be that peers broadcast clocks (and hashes) that they've changed or seen changes
 in, trying to be as specific as possible.
 
 On receipt of such a change message, a peer will check if this disagrees with its own version. If it does, it will
 decide on a reconciliation strategy based on the cardonality / data load in the node. The reconciliation will all
 be achieved by requesting sub trees – results will be merged in.
 
 There's an asymetry here, that I think can simplify things quite a lot. Reconciliation in the other direction happens
 when the other side requests sub trees and merges them in.
 
 Maybe.
 
 The "current time" can always just be the max in the working set + 1.

 */

protocol LWWTableListening {
    associatedtype Key: Hashable
    associatedtype Value
    associatedtype Time: Hashable & Comparable

    func handleInsert(key: Key, value: Value?, time: Time)
    func handleChange(key: Key, oldValue: Value?, newValue: Value?, oldTime: Time, newTime: Time)
}

protocol LWWClockListening {
    associatedtype Time: Hashable & Comparable

    func handleInsert(time: Time)
    func handleChange(oldTime: Time, newTime: Time)
}

struct LWWTable<Key: Hashable, Value, Time: Hashable & Comparable> {
    
    init(named name: String, lisener: AnyLWWTableListener<Key, Value, Time>?, clockListener: AnyLWWClockListener<Time>) {
        self.store = Store(named: name)
        self.listener = lisener
        self.clockListener = clockListener
    }
    
    subscript(_ key: Key) -> Value? {
        return store.records[key]?.value
    }
    
    func update(key: Key, value: Value?, time: Time) {
        
        guard let record = store.records[key] else {
            store.records[key] = Record(time: time, value: value)
            listener?.handleInsert(key: key, value: value, time: time)
            clockListener?.handleInsert(time: time)
            return
        }
        
        guard time > record.time else {
            return
        }
        
        store.records[key] = Record(time: time, value: value)
        listener?.handleChange(key: key, oldValue: record.value, newValue: value, oldTime: record.time, newTime: time)
        clockListener?.handleChange(oldTime: record.time, newTime: time)
    }
    
    let listener: AnyLWWTableListener<Key, Value, Time>?
    let clockListener: AnyLWWClockListener<Time>?

    let store: Store
    
    final class Store {
        
        init(named name: String) {
            self.name = name
        }
        
        let name: String
        var records: [Key: Record] = [:]
    }
    
    struct Record {
        let time: Time
        let value: Value?
    }
}

extension LWWTable.Record: Codable where Key: Codable, Value: Codable, Time: Codable {}
extension LWWTable.Store: Codable where Key: Codable, Value: Codable, Time: Codable {}
