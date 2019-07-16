//
//  CoinsTest.swift
//  MergebaseTests
//
//  Created by Benjohn on 16/07/2019.
//  Copyright © 2019 splendid-things. All rights reserved.
//

import XCTest

class CoinsTest: XCTestCase {

    func testCoins() {
        
        XCTAssertEqual(waysToMake(0, using: []), 1)
        XCTAssertEqual(waysToMake(10, using: []), 0)
        
        XCTAssertEqual(waysToMake(10, using: [1]), 1)
        XCTAssertEqual(waysToMake(5, using: [1]), 1)
        XCTAssertEqual(waysToMake(10, using: [2]), 1)
        XCTAssertEqual(waysToMake(8, using: [2]), 1)
        XCTAssertEqual(waysToMake(9, using: [2]), 0)

        XCTAssertEqual(waysToMake(7, using: [1,2,3]), 8)
        XCTAssertEqual(waysToMake(7, using: [1,2,3,4]), 11)

        XCTAssertEqual(waysToMake(1, using: [1,1]), 2)
        XCTAssertEqual(waysToMake(2, using: [1,1]), 3)

    }
}

func waysToMake(_ queryAmount: Int, using coins: [Int]) -> Int {
    
    var waysToMake: [Int: Int] = [0: 1]
    
    for coin in coins {
        guard coin <= queryAmount else { continue }
        for amount in coin...queryAmount {
            waysToMake[amount] = waysToMake[amount, default: 0] + waysToMake[amount - coin, default: 0]
        }
    }
    
    return waysToMake[queryAmount, default: 0]
}
