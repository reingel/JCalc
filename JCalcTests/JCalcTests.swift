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
    
    func testStack() {
        var stack = Stack<Int>()
        
        stack.push(1)
        stack.push(2)
        if let ret = stack.pop() { print(ret) }
        if let ret = stack.pop() { print(ret) }
        if let ret = stack.pop() { print(ret) }
    }
    
    func testQueue() {
        var queue = Queue<Int>()
        
        queue.push(1)
        queue.push(2)
        if let ret = queue.pop() { print(ret) }
        if let ret = queue.pop() { print(ret) }
        if let ret = queue.pop() { print(ret) }
    }
    
    func testUnitList() {
        let a = PhysicalValue(1, "km")
        let b = PhysicalValue(200, "m")
        let c = PhysicalValue(1200, .length)
        let d = PhysicalValue(1000*200, "m^2")
        
        XCTAssert(a + b == c)
        XCTAssert(a * b == d)
        XCTAssert(c.valueIn("km") == 1.2)
    }
    
    func testMathOperator() {
        let a = mathOperators["("]
        print(a!.priority)
        print(MathOperator.addition.priority)
    }
    
    func testExpression() {
        print("")
        
//        let string = "1km + 200m * (3 - 1)"
//        let string = "1 + 2 ^ 9 * 3 + 4 / 5 - 6 ^ 2"
        let string = "1+2^9*3+4/5-6^2"
        
        var expression = Expression()
        let ans = expression.evaluate(string)
        print(ans)
        
        print("")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
