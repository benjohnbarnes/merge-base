//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest
import Mergebase

class NodeCodingTests: XCTestCase {

    func testExample() {
        validateCoding(of: .bool(true))
        validateCoding(of: .bool(false))
        
        validateCoding(of: .number(10))
        validateCoding(of: .number(10000000))
        
        validateCoding(of: .string(""))
        validateCoding(of: .string("Hello World!"))

        validateCoding(of: .data(Data()))
        validateCoding(of: .data("Hello World!".data(using: .utf8)!))

        validateCoding(of: .identifier(NodeIdentifier()))

        validateCoding(of: .variant(VariantIdentifier(), .string("Hello Pants")))
        validateCoding(of: .variant(VariantIdentifier(), .number(10)))
        
        validateCoding(of: .type(.anything))

        validateCoding(of: .tuple([]))
        validateCoding(of: .tuple([.number(10), .number(11)]))
        
        validateCoding(of: .set(Set()))
        validateCoding(of: .set(Set([.number(1), .number(2), .number(3)])))
        
        validateCoding(of: .array([]))
        validateCoding(of: .array([.number(10), .number(11), .number(12)]))
    }
    
    private func validateCoding(of node: Node, file: StaticString = #file, line: UInt = #line) {
        super.validateCoding(of: node, file: file, line: line)
    }
}
