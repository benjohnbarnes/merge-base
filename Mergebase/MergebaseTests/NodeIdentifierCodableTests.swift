//
//  NodeIdentifierCodableTests.swift
//  MergebaseTests
//
//  Created by Benjohn on 18/07/2019.
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest
import Mergebase

class NodeIdentifierCodableTests: XCTestCase {

    func test_NodeIdentifier() {
        validateCoding(of: NodeIdentifier())
        validateCoding(of: NodeIdentifier.string("sadfadf"))
        validateCoding(of: NodeIdentifier.uuid(UUID()))
        validateCoding(of: NodeIdentifier.url(URL(fileURLWithPath: "/blah/blah/blah")))
    }
    
    func test_VariantIdentifier() {
        validateCoding(of: VariantIdentifier())
        validateCoding(of: VariantIdentifier(.string("adsfadf")))
        validateCoding(of: VariantIdentifier(.uuid(UUID())))
        validateCoding(of: VariantIdentifier(.url(URL(fileURLWithPath: "/things/stuff"))))
    }
}
