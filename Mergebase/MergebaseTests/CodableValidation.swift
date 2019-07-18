//
//  CodableValidation.swift
//  MergebaseTests
//
//  Created by Benjohn on 18/07/2019.
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func validateCoding<T: Codable & Equatable>(of codable: T, file: StaticString = #file, line: UInt = #line) {
        
        let coder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let data = try coder.encode(codable)
            let decoded = try decoder.decode(T.self, from: data)
            XCTAssertEqual(codable, decoded, file: file, line: line)
        }
        catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
}
