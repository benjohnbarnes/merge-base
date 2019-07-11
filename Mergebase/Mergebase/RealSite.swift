//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


final class Site: SiteType {
    
    init() {
        let internals = SiteInternals()
        rootTable = internals.createTable()
        self.internals = internals
    }
    
    let rootTable: Table
    let internals: SiteInternals
}

final class SiteInternals {
    
    init() {
    }

    private let id = UUID()
    private var clock = UInt64(0)
    private var tables = [TableId: InternalTable]()
    private var log = [Operation]()
}


fileprivate extension SiteInternals {
    
    func logOperation(_ operation: Operation) {
        log.append(operation)
    }
    
    func newChangeId() -> ChangeId {
        let oldClock = clock
        clock = clock + 1
        return ChangeId(site: self.id, clock: oldClock)
    }
}

extension SiteInternals {
    
    func createTable() -> Table {
        let tableId = newTableId()
        return Table(id: tableId, backing: self)
    }

    private func newTableId() -> TableId {
        return TableId()
    }
}

extension SiteInternals: TableAccessing {
    
    func keys(_ tableId: TableId) -> Set<Node> {
        return tables[tableId]!.keys
    }
    
    func get(table tableId: TableId, key: Node) -> Node? {
        return tables[tableId]!.get(key: key)
    }
    
    func set(table tableId: TableId, key: Node, value: Node?) {
        let changeId = newChangeId()

        let operation = Operation(id: changeId, command: .setTable(table: tableId, key: key, value: value))
        logOperation(operation)

        executeSetTable(changeId: changeId, table: tableId, key: key, value: value)
    }
    
    func executeSetTable(changeId: ChangeId, table: TableId, key: Node, value: Node?) {
        guard let table = tables[table] else { fatalError() }
        return table.performSet(change: changeId, key: key, value: value)
    }
}


//MARK:-

struct ChangeId: Hashable, Comparable {

    static func < (lhs: ChangeId, rhs: ChangeId) -> Bool {
        if lhs.clock == rhs.clock { return lhs.site.uuidString < rhs.site.uuidString }
        return lhs.clock < rhs.clock
    }
    
    let site: UUID
    let clock: UInt64
}

struct TableId: Hashable {
    let id = UUID()
}

// Operations

private struct Operation {
    
    let id: ChangeId
    let command: Command
    
    enum Command {
        case setTable(table: TableId, key: Node, value: Node?)
    }
}
