//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


enum Node: Hashable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    
    case dictionary([Node: Node])
    case array([Node])
    
    case table(Table)
}

protocol SiteType {
    var rootTable: Table {get}
}

protocol TableAccessing {
    func keys(_: TableId) -> Set<Node>
    func set(table: TableId, key: Node, value: Node?)
    func get(table: TableId, key: Node) -> Node?
}

struct Table: Hashable {
    let id: TableId
    let backing: TableAccessing

    var keys: Set<Node> {
        return backing.keys(id)
    }
    
    subscript(_ key: Node) -> Node? {
        get {
            return backing.get(table: id, key: key)
        }
        set {
            backing.set(table: id, key: key, value: newValue)
        }
    }
    
    static func == (lhs: Table, rhs: Table) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

