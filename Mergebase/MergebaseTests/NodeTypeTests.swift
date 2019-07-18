//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest

import Mergebase

class NodeTypeTests: XCTestCase {

    func test_unitConformanceCheck() {
        let unit = Node.unit
        checkConformance(of: unit, to: .unit)
        checkNonConformance(of: unit, except: .unit)
    }
    
    func test_boolConformanceChecks() {
        let bool = Node.bool(true)
        checkConformance(of: bool, to: .bool)
        checkNonConformance(of: bool, except: .bool)
    }
    
    func test_numberConformanceChecks() {
        let number = Node.number(10)
        checkConformance(of: number, to: .number(nil))
        checkNonConformance(of: number, except: .number(nil))
        
        XCTAssertFalse(number.conforms(to: .number(0..<10)))
        XCTAssertTrue(number.conforms(to: .number(5..<15)))
        XCTAssertTrue(number.conforms(to: .number(10..<20)))
        XCTAssertFalse(number.conforms(to: .number(11..<20)))
    }
    
    func test_stringConformanceChecks() {
        let string = Node.string("hello")
        checkConformance(of: string, to: .string(nil))
        checkNonConformance(of: string, except: .string(nil))
        
        XCTAssert(string.conforms(to: .string(5..<6)))
        XCTAssertFalse(string.conforms(to: .string(10..<20)))
        XCTAssertFalse(string.conforms(to: .string(0..<3)))
    }
    
    func test_dataConformanceChecks() {
        let data = Node.data("Hello".data(using: .utf8)!)
        checkConformance(of: data, to: .data(nil))
        checkNonConformance(of: data, except: .data(nil))

        XCTAssert(data.conforms(to: .data(0..<100)))
        XCTAssertFalse(data.conforms(to: .data(20..<100)))
        XCTAssertFalse(data.conforms(to: .data(0..<3)))
    }
    
    func test_identifierConformanceChecks() {
        let identifier = Node.identifier(Unique())
        checkConformance(of: identifier, to: .identifier)
        checkNonConformance(of: identifier, except: .identifier)
    }
    
    func test_tupleConformanceChecks() {
        let tuple = Node.tuple([.string("hello"), .number(10)])
        checkConformance(of: tuple, to: .tuple([.string(nil), .number(nil)]))
        checkNonConformance(of: tuple, except: nil)
        
        XCTAssertTrue(tuple.conforms(to: .tuple([.anything, .anything])))
        XCTAssertTrue(tuple.conforms(to: .tuple([.string(nil), .anything])))
        XCTAssertTrue(tuple.conforms(to: .tuple([.anything, .number(nil)])))
        XCTAssertTrue(tuple.conforms(to: .tuple([.string(nil), .number(nil)])))

        XCTAssertFalse(tuple.conforms(to: .tuple([])))
        XCTAssertFalse(tuple.conforms(to: .tuple([.anything])))
        XCTAssertFalse(tuple.conforms(to: .tuple([.anything, .anything, .anything])))
        XCTAssertFalse(tuple.conforms(to: .tuple([.number(nil), .anything])))
        XCTAssertFalse(tuple.conforms(to: .tuple([.anything, .string(nil)])))
    }
    
    func test_setConformanceChecks() {
        let set1 = Node.set(Set([.string("hello"), .number(10)]))
        checkConformance(of: set1, to: .set(.anything, nil))
        checkNonConformance(of: set1, except: nil)
        
        XCTAssertTrue(set1.conforms(to: .set(.anything, 0..<10)))
        XCTAssertFalse(set1.conforms(to: .set(.anything, 3..<10)))

        let numberSet = Node.set(Set([.number(10), .number(11)]))
        checkConformance(of: numberSet, to: .set(.number(nil), nil))
        checkNonConformance(of: numberSet, except: nil)

        XCTAssertTrue(numberSet.conforms(to: .set(.number(9..<12), nil)))
        XCTAssertFalse(numberSet.conforms(to: .set(.number(9..<12), 1..<2)))
        XCTAssertTrue(numberSet.conforms(to: .set(.number(9..<12), 2..<3)))
        XCTAssertFalse(numberSet.conforms(to: .set(.number(9..<12), 3..<4)))
    }
    
    func test_arrayConformanceChecks() {
        let array = Node.array([.string("hello"), .number(10)])
        checkConformance(of: array, to: .array(.anything, nil))
        checkNonConformance(of: array, except: nil)
    }
    
    func test_variantConformanceChecks() {
        let variant = Node.variant("left", .number(10))
        checkConformance(of: variant, to: .variant(["left": .number(nil), "right": .number(nil)]))
        checkNonConformance(of: variant, except: nil)
        
        XCTAssertTrue(variant.conforms(to: .variant(["left": .number(nil)])))

        XCTAssertFalse(variant.conforms(to: .variant([:])))
        XCTAssertFalse(variant.conforms(to: .variant(["right": .number(nil)])))
        XCTAssertFalse(variant.conforms(to: .variant(["left": .unit])))
        XCTAssertFalse(variant.conforms(to: .variant(["left": .number(100..<101)])))
    }

    //MARK:-
    
    private func checkConformance(of node: Node, to type: StructuralNodeType, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(node.conforms(to: .anything))
        XCTAssert(node.conforms(to: type))
    }
    
    private func checkNonConformance(of node: Node, except excludedType: StructuralNodeType?, file: StaticString = #file, line: UInt = #line) {
        
        let types: [StructuralNodeType] = [
            .unit,
            .bool,
            .number(nil),
            .string(nil),
            .data(nil),
            .identifier,
            .tuple([.string(nil), .string(nil)]),
            .set(.string(nil), nil),
            .set(.string(nil), 0..<2),
            .array(.string(nil), 0..<2),
            .variant([:])
        ]

        for type in types {
            if let excludedType = excludedType { guard type != excludedType else { continue } }
            XCTAssertFalse(node.conforms(to: type), "Found \(node) wrongly conforming to \(type)", file: file, line: line)

        }
    }
}
