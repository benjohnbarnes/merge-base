//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation


protocol SiteType {
    associatedtype Table: TableType
    associatedtype List: ListType
    
    var rootTable: Table {get}
    
    func createTable() -> Table
    func createList() -> List
}


enum Node<Site: SiteType>: Hashable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    
    case dictionary([Node: Node])
    case array([Node])
    
    case table(Site.Table)
    case list(Site.List)
}

protocol TableType: Hashable {
    associatedtype Site: SiteType where Site.Table == Self
    
    var keys: Set<Node<Site>> {get}
    
    subscript(_: Node<Site>) -> Node<Site>? {get set}
}

protocol ListType: Hashable {
    associatedtype Site: SiteType where Site.List == Self
    
    var count: Int {get}
    
    subscript(_: Int) -> Node<Site> {get set}
    
    func delete(_ : Int)
}

