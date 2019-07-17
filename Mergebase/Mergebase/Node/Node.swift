//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import Foundation

enum Node: Hashable {
    case bool(Bool)
    case number(Double)
    case string(String)
    
    case set(Set<Node>)
    case tuple([Node])

    case reference(Unique)
}

struct Unique: Hashable {
    private let identifier = UUID()
}

