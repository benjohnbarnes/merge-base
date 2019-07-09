//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


final class RealSite: SiteType {
    
    init() {
        rootTable = createTable()
    }
    
    func createTable() -> RealTable {
        let id = newTableId()
        // TODO – record instruction
        return createTable(id)
    }

    func createList() -> RealList {
        let id = newListId()
        // TODO – record instruction
        return createList(id)
    }
    
    func set(table: RealTable, key: Node<RealSite>, value: Node<RealSite>?) {
        let change = newChangeId()
        // TODO – record instruction
        setTable(change: change, table: table.id, key: key, value: value)
    }
    
    func insert(list: RealList, index: Int, value: Node<RealSite>) {
        // TODO – record instruction
        // Perform insert.
    }
    
    let rootTable: RealTable

    private let id = UUID()
    private var clock = UInt64(0)
    
    private var tables = [TableId: RealTable]()
    private var lists = [ListId: RealList]()
}


// Mechanism to ensure that commands are not executed until commands they depend on are realised.
private protocol DependencyChecking {
    var dependencies: Set<ChangeId> { get }
}

extension Node: DependencyChecking where Site == RealSite {
    
    fileprivate var dependencies: Set<ChangeId> {
    
        switch self {
        case let .table(table):
            return Set([table.id.id])
            
        case let .list(list):
            return Set([list.id.id])

        case let .array(nodes):
            var dependencies = Set<ChangeId>()
            nodes.forEach {
                dependencies.formUnion($0.dependencies)
            }
            
            return dependencies

        case let .dictionary(dictionary):
            var dependencies = Set<ChangeId>()
            dictionary.forEach {
                dependencies.formUnion($0.key.dependencies)
                dependencies.formUnion($0.value.dependencies)
            }
            
            return dependencies

        default:
            return Set()
        }
    }
}

private struct Operation {
    
    let id: ChangeId
    let command: Command
    
    enum Command {
        case createTable
        case createList
        
        case setTable(table: TableId, key: Node<RealSite>, value: Node<RealSite>?)
    }
}

extension Operation: DependencyChecking {
    
    fileprivate var dependencies: Set<ChangeId> {
        var dependencies = Set<ChangeId>([id])
        
        switch command {
        case .createTable:
            break
            
        case .createList:
            break
            
        case let .setTable(table: table, key: key, value: value):
            dependencies.insert(table.id)
            dependencies.formUnion(key.dependencies)
            dependencies.formUnion(value?.dependencies ?? Set())
        }
        
        return dependencies
    }
}


// Implement operations. They're either local or being played back.

private extension RealSite {
    
    func createTable(_ id: TableId) -> RealTable {
        guard tables[id] == nil else { fatalError() }
        let table = RealTable(id: id, site: self)
        tables[id] = table
        return table
    }
    
    func setTable(change: ChangeId, table: TableId, key: Node<RealSite>, value: Node<RealSite>?) {
    }
    
    func createList(_ id: ListId) -> RealList {
        guard lists[id] == nil else { fatalError() }
        let newList = RealList(id: id, site: self)
        lists[id] = newList
        return newList
    }
    
    func newTableId() -> TableId {
        return TableId(id: newChangeId())
    }
    
    func newListId() -> ListId {
        return ListId(id: newChangeId())
    }
    
    func newChangeId() -> ChangeId {
        let oldClock = clock
        clock = clock + 1
        return ChangeId(site: self.id, clock: oldClock)
    }
}

//MARK:-

private struct ChangeId: Hashable, Comparable {

    static func < (lhs: ChangeId, rhs: ChangeId) -> Bool {
        if lhs.clock == rhs.clock { return lhs.site.uuidString < rhs.site.uuidString }
        return lhs.clock < rhs.clock
    }
    
    let site: UUID
    let clock: UInt64
}

private struct TableId: Hashable, Comparable {
    
    static func < (lhs: TableId, rhs: TableId) -> Bool {
        return lhs.id < rhs.id
    }
    
    let id: ChangeId
}

private struct ListId: Hashable, Comparable {
    
    static func < (lhs: ListId, rhs: ListId) -> Bool {
        return lhs.id < rhs.id
    }
    
    let id: ChangeId
}


//MARK:-

final class RealTable: TableType {

    fileprivate init(id: TableId, site: RealSite) {
        self.id = id
        self.site = site
    }

    var keys: Set<Node<RealSite>>
    
    subscript(_ key: Node<RealSite>) -> Node<RealSite>? {
        get {
            return table[key]?.value
        }
        set {
            site?.set(table: self, key: key, value: newValue)
        }
    }
    
    static func == (lhs: RealTable, rhs: RealTable) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    
    fileprivate let id: TableId
    fileprivate weak var site: RealSite?
    
    private var table: [Node<RealSite>: TableSlot]
    
    private struct TableSlot {        
        let updateId: ChangeId
        let value: Node<RealSite>?
    }
}


final class RealList: ListType {

    fileprivate init(id: ListId, site: RealSite) {
        self.id = id
        self.site = site
    }
    
    var count: Int
    
    subscript(_: Int) -> Node<RealSite> {
        get {
            <#code#>
        }
        set {
            <#code#>
        }
    }
    
    func delete(_: Int) {
        <#code#>
    }
    
    static func == (lhs: RealList, rhs: RealList) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    fileprivate let id: ListId
    fileprivate weak var site: RealSite?
}
