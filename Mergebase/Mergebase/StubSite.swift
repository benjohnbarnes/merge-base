//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

final class StubSite: SiteType {
    init() {}
    
    var rootTable = Table()
    
    func createList() -> StubList {
        return StubList()
    }
    
    func createTable() -> StubTable {
        return StubTable()
    }
}

final class StubTable: TableType {
    
    fileprivate init() {}
    
    var keys: Set<Node<StubSite>> {
        return Set(table.keys)
    }
    
    subscript(_ key: Node<StubSite>) -> Node<StubSite>? {
        get {
            return table[key]
        }
        set {
            guard let newValue = newValue else {
                table.removeValue(forKey: key)
                return
            }
            
            table[key] = newValue
        }
    }
    
    static func == (lhs: StubTable, rhs: StubTable) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
    
    private var table = [Node<StubSite>: Node<StubSite>]()
    
    //    typealias Site = StubSite
}

final class StubList: ListType {
    init() {}
    
    var count: Int {
        return list.count
    }
    
    subscript(_ i: Int) -> Node<StubSite> {
        get {
            return list[i]
        }
        
        set {
            list[i] = newValue
        }
    }
    
    func delete(_ i: Int) {
        list.remove(at: i)
    }
    
    static func == (lhs: StubList, rhs: StubList) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var list = [Node<StubSite>]()
}
