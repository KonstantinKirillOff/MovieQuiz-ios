//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Konstantin Kirillov on 26.11.2022.
//

import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
    
    func asyncAddition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 + num2)
        }
    }
    
    func asyncSubtruction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func asyncMultiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
}

class MovieQuizTests: XCTestCase {
    func testAdditional() throws {
        
        //Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //When
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        //Then
        XCTAssertEqual(result, 3)
    }
    
    func testAsyncAditional() throws {
        
        //Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //When
        let expectation = expectation(description: "Addition function expectation")
        
        arithmeticOperations.asyncAddition(num1: num1, num2: num2) { result in
            //Then
            XCTAssertEqual(result, 3)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }

}
