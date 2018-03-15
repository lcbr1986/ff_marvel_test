//
//  MD5Tests.swift
//  Marvel SuperheroesTests
//
//  Created by Luis Carlos Rosa on 15/03/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import XCTest
@testable import Marvel_Superheroes

class MD5Tests: XCTestCase {
    
    func testMD5Hashing() {
        let originalString = "1a9420be765d8255c52a6896f4699d3e59a1f8364b56deb618cadad85723376a7c4956743"
        let expectedString = "a463e65289522e5e8b2093ee32e97f2a"
        
        let networkController = NetworkController(baseUrl: "url")
        
        let hashedString = networkController.md5(originalString)
        
        XCTAssertEqual(expectedString, hashedString)
    }
}
