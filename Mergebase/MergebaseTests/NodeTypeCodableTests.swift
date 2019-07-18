//
//  NodeTypeCodableTests.swift
//  MergebaseTests
//
//  Created by Benjohn on 18/07/2019.
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest
import Mergebase

class NodeTypeCodableTests: XCTestCase {

    func testExample() {
        validateCoding(of: .anything)

        validateCoding(of: .bool)
        
        validateCoding(of: .identifier)
        
        validateCoding(of: .type)
        
        validateCoding(of: .array(.bool, nil))
        validateCoding(of: .array(.bool, 10..<20))

        validateCoding(of: .data(nil))
        validateCoding(of: .data(0..<100))
        
        validateCoding(of: .set(.bool, nil))
        validateCoding(of: .set(.bool, 0..<100))
        
        validateCoding(of: .number(nil))
        validateCoding(of: .number(100..<200))
        
        validateCoding(of: .nominal(NominalNodeType(type: .string(nil))))
        
        validateCoding(of: .variant([:]))
        validateCoding(of: .variant([VariantIdentifier(): .bool, VariantIdentifier(): .string(nil)]))

        validateCoding(of: .tuple([]))
        validateCoding(of: .tuple([.anything]))
        validateCoding(of: .tuple([.anything, .bool]))

    }

    private func validateCoding(of node: NodeType, file: StaticString = #file, line: UInt = #line) {
        super.validateCoding(of: node, file: file, line: line)
    }
}

