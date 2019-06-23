//
//  JCalcTests.swift
//  JCalcTests
//
//  Created by Soonkyu Jeong on 2019/06/17.
//  Copyright © 2019 Soonkyu Jeong. All rights reserved.
//

import XCTest

class JCalcTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var temp = TemperatureValue()
        temp["C"] = 0
        XCTAssert(temp["K"]! == 273.15)
        XCTAssert(abs(temp["F"]! - 32.0) < 1e-9)
    }
    
    func testUnitList() {
        let a = PhysicalValue(1, "km")
        let b = PhysicalValue(200, "m")
        let c = PhysicalValue(1200, .length)
        let d = PhysicalValue(1000*200, "m^2")
        
        XCTAssert(a + b == c)
        XCTAssert(a * b == d)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
