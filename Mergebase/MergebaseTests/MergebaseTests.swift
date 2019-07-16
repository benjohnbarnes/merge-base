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
    
    let peopleDOBStrings: [Person: String] = [
        .ben: "09/07/1975",
        .misa: "03/10/1972",
        .robin: "19/01/2007",
        .tobi: "18/09/2009",
        .emily: "20/03/2012",
        .eli: "15/06/2015"
    ]
    
    func testExample() {
        let longNames = peopleNames.intersection(peopleNames.mapValue{ $0.count }.whereValue{ $0>=7 })
        XCTAssertEqual(longNames.records().count, 3)
    }
    
    func testAges() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let peopleDOBs = peopleDOBStrings.mapValue { formatter.date(from: $0)! }
        
        let today = formatter.date(from: "16/07/2019")!
        let calendar = Calendar(identifier: .gregorian)

        func age(_ date: Date) -> Int {
            return calendar.dateComponents([.year], from: date, to: today).year!
        }

        let peopleAges = peopleDOBs.mapValue{ age($0) }
        
        let children = peopleAges.whereValue{ $0 < 16 }

        XCTAssertEqual(Set(children.records().keys), Set<Person>([.robin, .tobi, .emily, .eli]))
    }
}


