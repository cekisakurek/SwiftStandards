//
//  AlgebraTests.swift
//  AlgebraTests
//
//  Created by Cihan Emre Kisakurek (Company) on 04.01.19.
//  Copyright © 2019 rocks.cihan. All rights reserved.
//

import XCTest
@testable import Algebra

class AlgebraTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWithoutAnyLabel() {
        for i in 0...100 {
            let varOne = Variable(constant: Double(i))
            let varTwo = Variable(constant: Double(i))
            // i + i
            let equation:Equation = varOne + varTwo
            let expected = Double(i+i)
            do {
                let result:Double = try equation.solve()
                if result != expected {
                    XCTAssert(false,"expecting: \(expected) got: \(result)")
                }
            }
            catch {
                XCTAssert(false,"error :\(error)")
            }
        }
    }

    func testWithOneLabel() {
        do {
            let label = VariableLabel(name: "X")
            var varOne = Variable(label: label)
            varOne.multiplier = 2.0

            var varTwo = Variable()
            varTwo.constant = 2

            // 2x + 2 = 0
            // x = -1
            let equation = (varOne + varTwo).equal(variable: Variable(constant: 0.0))
            let expected = -1.0
            do {
                let result:Double = try equation.solve()
                if result != expected {
                    XCTAssert(false,"expecting: \(expected) got: \(result)")
                }
            }
            catch {
                XCTAssert(false,"error :\(error)")
            }
        }

        do {
            let label = VariableLabel(name: "X")
            var varOne = Variable(label: label)
            varOne.multiplier = 0.5

            var varTwo = Variable()
            varTwo.constant = 123

            // x/2 + 123 = 0
            // x = -123/2
            let equation = (varOne + varTwo).equal(variable: Variable(constant: 0.0))
            let expected = -123*0.5
            do {
                let result:Double = try equation.solve()
                if result != expected {
                    XCTAssert(false,"expecting: \(expected) got: \(result)")
                }
            }
            catch {
                XCTAssert(false,"error :\(error)")
            }
        }

        do {
            let label = VariableLabel(name: "X")
            var varOne = Variable(label: label)
            varOne.multiplier = 2.0

            var varTwo = Variable()
            varTwo.constant = 123

            // 2x + 123 = 0
            // x = -123/2
            let equation = (varOne + varTwo).equal(variable: Variable(constant: 0.0))
            let expected = -123/2.0
            do {
                let result:Double = try equation.solve()
                if result != expected {
                    XCTAssert(false,"expecting: \(expected) got: \(result)")
                }
            }
            catch {
                XCTAssert(false,"error :\(error)")
            }
        }
    }

    func testWithTwoSameLabels() {
        do {
            var varOne = Variable(label: VariableLabel(name: "X"))
            varOne.multiplier = 2.0

            let varTwo = Variable(label: VariableLabel(name: "X"))
            // 2x + x = 3
            // x = 1
            let equation = (varOne + varTwo).equal(variable: Variable(constant: 3.0))
            let expected = 1.0
            do {
                let result:Double = try equation.solve()
                if result != expected {
                    XCTAssert(false,"expecting: \(expected) got: \(result)")
                }
            }
            catch {
                XCTAssert(false,"error :\(error)")
            }
        }

        do {
            var varOne = Variable(label: VariableLabel(name: "X"))
            varOne.multiplier = 0.2

            let varTwo = Variable(label: VariableLabel(name: "X"))
            // 2x/10 + x = 123
            // x = 1
            let equation = (varOne + varTwo).equal(variable: Variable(constant: 123.0))
            let expected = 123.0*10.0/12.0
            do {
                let result:Double = try equation.solve()
                if result != expected {
                    XCTAssert(false,"expecting: \(expected) got: \(result)")
                }
            }
            catch {
                XCTAssert(false,"error :\(error)")
            }
        }

    }

    func testWithTwoDifferentLabels() {
        do {
            var varOne = Variable(label: VariableLabel(name: "X"))
            varOne.multiplier = 2.0

            let varTwo = Variable(label: VariableLabel(name: "Y"))
            // 2x + y = 0
            // x = -y/2
            let equation = (varOne + varTwo).equal(variable: Variable(constant: 0.0))
            let expected = Double.greatestFiniteMagnitude
            do {
                let result:Double = try equation.solve()
                if result != expected {
                    XCTAssert(false,"expecting: \(expected) got: \(result)")
                }
            }
            catch SolveError.needsSolveForLabel {
                do {
                    let line = equation as! LineEquation
                    do {
                        let newResult = try line.solveFor(label: VariableLabel(name: "X"), value: 10.0) as Equation
                        let y = -20.0
                        let r = try newResult.solve()
                        if r != y {
                            XCTAssert(false,"expecting: \(expected) got: \(r)")
                        }
                    }
                    catch {
                        XCTAssert(false,"error :\(error)")
                    }
                }
                do {
                    let line = equation as! LineEquation
                    do {
                        let newResult = try line.solveFor(label: VariableLabel(name: "Y"), value: 10.0) as Equation
                        let x = -5.0
                        let r = try newResult.solve()
                        if r != x {
                            XCTAssert(false,"expecting: \(expected) got: \(r)")
                        }
                    }
                    catch {
                        XCTAssert(false,"error :\(error)")
                    }
                }
            }
            catch {
                XCTAssert(false,"error :\(error)")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
