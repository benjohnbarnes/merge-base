//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest
@testable import Mergebase

class MergebaseTests: XCTestCase {

    enum Person {
        case ben
        case misa
        case robin
        case tobi
        case emily
        case eli
    }
    
    let peopleNames: [Person: String] = [
        .ben: "Benjohn",
        .misa: "Michaela",
        .robin: "Robin",
        .tobi: "Tobiash",
        .emily: "Emily",
        .eli: "Eliash"
    ]
    
    
    func testExample() {
        let longNames = peopleNames.intersection(peopleNames.map{ $0.count }.whereValue({$0>=7}))
        XCTAssertEqual(longNames.records().count, 3)
    }
}
