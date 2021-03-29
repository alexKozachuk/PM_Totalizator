//
//  ValidatorTests.swift
//  ValidatorTests
//
//  Created by leonid yabkovych on 29.03.2021.
//

import XCTest
@testable import PMProject

class ValidatorTests: XCTestCase {
    var loginValidator = LoginValidator()
    
    func testLogin() {
        let exp = expectation(description: "should be successful login")
        
        let expectedSuccess = loginValidator.validate(email: "email@email.com", password: "password")
        let success = LoginValidatorError.success
        
        XCTAssertEqual(expectedSuccess, success)
        
        exp.fulfill()
        
        wait(for: [exp], timeout: 5)
    }
    
    func testEmail() {
        let exp = expectation(description: "should return error due to incorrect email")
        
        let expectedIncorrectEmail = loginValidator.validate(email: "email@email", password: "password")
        let expectedNilEmail = loginValidator.validate(email: "", password: "password")
        let incorrectEmail = LoginValidatorError.invalidEmail
        
        XCTAssertEqual(expectedIncorrectEmail, incorrectEmail)
        XCTAssertEqual(expectedNilEmail, LoginValidatorError.emptyEmail)
        
        exp.fulfill()
        
        wait(for: [exp], timeout: 5)
    }
    
    func testPassword() {
        let exp = expectation(description: "should return error due to incorrect password")
        
        let expectedNilPassword = loginValidator.validate(email: "email@email.com", password: "")
        let expectedSmallPassword = loginValidator.validate(email: "email@email.com", password: "123")
        
        XCTAssertEqual(expectedNilPassword, LoginValidatorError.emptyPassword)
        XCTAssertEqual(expectedSmallPassword, LoginValidatorError.invalidPassword)
        
        exp.fulfill()
        
        wait(for: [exp], timeout: 5)
    }
    
    func testDate() {
        let exp = expectation(description: "should return error due to small age")
        
        let expectedSuccess = loginValidator.validate(email: "email@email.com", password: "password", dateOfBirth: Date(timeIntervalSinceNow: -568036801))
        let expectedSmallAge = loginValidator.validate(email: "email@email.com", password: "password", dateOfBirth: Date(timeIntervalSinceNow: -568036799))
        
        XCTAssertEqual(expectedSmallAge, LoginValidatorError.invalidAge)
        XCTAssertEqual(expectedSuccess, LoginValidatorError.success)
        
        exp.fulfill()
        
        wait(for: [exp], timeout: 5)
    }
}
