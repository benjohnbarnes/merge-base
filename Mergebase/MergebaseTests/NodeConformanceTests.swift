//
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest

import Mergebase

class NodeConformanceTests: XCTestCase {

    let sut = NodeTypeValidator()
    
    func test_boolConformanceChecks() {
        let bool = Node.bool(true)
        checkConformance(of: bool, to: .bool)
        checkNonConformance(of: bool, except: .bool)
    }
    
    func test_numberConformanceChecks() {
        let number = Node.number(10)
        checkConformance(of: number, to: .number(nil))
        checkNonConformance(of: number, except: .number(nil))
        
        XCTAssertFalse(sut.validate(node: number, conformsTo: .number(0..<10)))
        XCTAssertTrue(sut.validate(node: number, conformsTo: .number(5..<15)))
        XCTAssertTrue(sut.validate(node: number, conformsTo: .number(10..<20)))
        XCTAssertFalse(sut.validate(node: number, conformsTo: .number(11..<20)))
    }
    
    func test_stringConformanceChecks() {
        let string = Node.string("hello")
        checkConformance(of: string, to: .string(nil))
        checkNonConformance(of: string, except: .string(nil))
        
        XCTAssert(sut.validate(node: string, conformsTo: .string(5..<6)))
        XCTAssertFalse(sut.validate(node: string, conformsTo: .string(10..<20)))
        XCTAssertFalse(sut.validate(node: string, conformsTo: .string(0..<3)))
    }
    
    func test_dataConformanceChecks() {
        let data = Node.data("Hello".data(using: .utf8)!)
        checkConformance(of: data, to: .data(nil))
        checkNonConformance(of: data, except: .data(nil))

        XCTAssert(sut.validate(node: data, conformsTo: .data(0..<100)))
        XCTAssertFalse(sut.validate(node: data, conformsTo: .data(20..<100)))
        XCTAssertFalse(sut.validate(node: data, conformsTo: .data(0..<3)))
    }
    
    func test_identifierConformanceChecks() {
        let identifier = Node.identifier(NodeIdentifier())
        checkConformance(of: identifier, to: .identifier)
        checkNonConformance(of: identifier, except: .identifier)
    }
    
    func test_typeConformanceChecks() {
        let type = Node.type(.string(nil))
        checkConformance(of: type, to: .type)
        checkNonConformance(of: type, except: .type)
    }
    
    func test_tupleConformanceChecks() {
        let tuple = Node.tuple([.string("hello"), .number(10)])
        checkConformance(of: tuple, to: .tuple([.string(nil), .number(nil)]))
        checkNonConformance(of: tuple, except: nil)
        
        XCTAssertTrue(sut.validate(node: tuple, conformsTo: .tuple([.anything, .anything])))
        XCTAssertTrue(sut.validate(node: tuple, conformsTo: .tuple([.string(nil), .anything])))
        XCTAssertTrue(sut.validate(node: tuple, conformsTo: .tuple([.anything, .number(nil)])))
        XCTAssertTrue(sut.validate(node: tuple, conformsTo: .tuple([.string(nil), .number(nil)])))

        XCTAssertFalse(sut.validate(node: tuple, conformsTo: .tuple([])))
        XCTAssertFalse(sut.validate(node: tuple, conformsTo: .tuple([.anything])))
        XCTAssertFalse(sut.validate(node: tuple, conformsTo: .tuple([.anything, .anything, .anything])))
        XCTAssertFalse(sut.validate(node: tuple, conformsTo: .tuple([.number(nil), .anything])))
        XCTAssertFalse(sut.validate(node: tuple, conformsTo: .tuple([.anything, .string(nil)])))
    }
    
    func test_setConformanceChecks() {
        let set1 = Node.set(Set([.string("hello"), .number(10)]))
        checkConformance(of: set1, to: .set(.anything, nil))
        checkNonConformance(of: set1, except: nil)
        
        XCTAssertTrue(sut.validate(node: set1, conformsTo: .set(.anything, 0..<10)))
        XCTAssertFalse(sut.validate(node: set1, conformsTo: .set(.anything, 3..<10)))

        let numberSet = Node.set(Set([.number(10), .number(11)]))
        checkConformance(of: numberSet, to: .set(.number(nil), nil))
        checkNonConformance(of: numberSet, except: nil)

        XCTAssertTrue(sut.validate(node: numberSet, conformsTo: .set(.number(9..<12), nil)))
        XCTAssertFalse(sut.validate(node: numberSet, conformsTo: .set(.number(9..<12), 1..<2)))
        XCTAssertTrue(sut.validate(node: numberSet, conformsTo: .set(.number(9..<12), 2..<3)))
        XCTAssertFalse(sut.validate(node: numberSet, conformsTo: .set(.number(9..<12), 3..<4)))
    }
    
    func test_arrayConformanceChecks() {
        let array = Node.array([.string("hello"), .number(10)])
        checkConformance(of: array, to: .array(.anything, nil))
        checkNonConformance(of: array, except: nil)
    }
    
    func test_variantConformanceChecks() {
        let left = VariantIdentifier()
        let right = VariantIdentifier()
        
        let variant = Node.variant(left, .number(10))
        checkConformance(of: variant, to: .variant([left: .number(nil), right: .number(nil)]))
        checkNonConformance(of: variant, except: nil)
        
        XCTAssertTrue(sut.validate(node: variant, conformsTo: .variant([left: .number(nil)])))

        XCTAssertFalse(sut.validate(node: variant, conformsTo: .variant([:])))
        XCTAssertFalse(sut.validate(node: variant, conformsTo: .variant([right: .number(nil)])))
        XCTAssertFalse(sut.validate(node: variant, conformsTo: .variant([left: .number(100..<101)])))
    }

    //MARK:-
    
    private func checkConformance(of node: Node, to type: NodeType, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(sut.validate(node: node, conformsTo: .anything), file: file, line: line)
        XCTAssert(sut.validate(node: node, conformsTo: type), file: file, line: line)
        
        XCTAssert(sut.validate(node: node, conformsTo: .nominal(NominalNodeType(type: .anything))), file: file, line: line)
        XCTAssert(sut.validate(node: node, conformsTo: .nominal(NominalNodeType(type: type))), file: file, line: line)
    }
    
    private func checkNonConformance(of node: Node, except excludedType: NodeType?, file: StaticString = #file, line: UInt = #line) {
        
        let types: [NodeType] = [
            .bool,
            .number(nil),
            .string(nil),
            .data(nil),
            .identifier,
            .type,
            .tuple([.string(nil), .string(nil)]),
            .set(.string(nil), nil),
            .set(.string(nil), 0..<2),
            .array(.string(nil), 0..<2),
            .variant([:])
        ]

        for type in types {
            if let excludedType = excludedType { guard type != excludedType else { continue } }
            XCTAssertFalse(sut.validate(node: node, conformsTo: type), "Found \(node) wrongly conforming to \(type)", file: file, line: line)
        }
    }
}

private extension Node {
    
}
