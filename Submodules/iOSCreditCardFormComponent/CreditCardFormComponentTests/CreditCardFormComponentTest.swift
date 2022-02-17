//
//  CreditCardFormComponentTest.swift
//  CreditCardFormComponentTests
//
//  Created by Ron on 07/02/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import XCTest
@testable import CreditCardFormComponent

class CreditCardFormComponentTest: XCTestCase {
    
    var creditCardForm: CreditCardForm!
    
    override func setUp() {
        super.setUp()
        
        creditCardForm = CreditCardForm()
    }
    
    func testCardNumberSet() {
        let cardNumber = "5123456789012346"
        creditCardForm.cardNumberField.number = cardNumber

        XCTAssertEqual(creditCardForm.cardNumber, cardNumber)
    }
    
    func testExpiryYear() {
        let expiryYear = "2016"
        creditCardForm.expiryField.expirationDate = "102016"
        
        XCTAssertEqual(creditCardForm.expiryYear, expiryYear)
    }
    
    func testExpiryMonth() {
        let expiryMonth = "10"
        creditCardForm.expiryField.expirationDate = "102016"
        
        XCTAssertEqual(creditCardForm.expiryMonth, expiryMonth)
    }
    
    func testChangeFieldHeight() {
        let height: CGFloat = 100
        
        creditCardForm.fieldHeight = height
        
        XCTAssertEqual(creditCardForm.cardNumberFieldHeightConstraint?.constant, height)
        XCTAssertEqual(creditCardForm.securityFieldHeightConstraint?.constant, height)
        XCTAssertEqual(creditCardForm.expiryFieldHeightConstraint?.constant, height)
    }
    
    func testIsValid() {
        creditCardForm.cardNumberField.number = "5123456789012346"
        creditCardForm.expiryField.expirationDate = "122030"
        creditCardForm.securityField.text = "123"
        
        XCTAssertTrue(creditCardForm.isValid)
    }
    
    func testIsInvalidNoCardNumber() {
        creditCardForm.expiryField.expirationDate = "122030"
        creditCardForm.securityField.text = "123"
        
        XCTAssertFalse(creditCardForm.isValid)
    }
    
    func testIsInvalidNoExpiry() {
        creditCardForm.cardNumberField.number = "5123456789012346"
        creditCardForm.securityField.text = "123"
        
        XCTAssertFalse(creditCardForm.isValid)
    }
    
    func testIsInvalidNoSecurity() {
        creditCardForm.cardNumberField.number = "5123456789012346"
        creditCardForm.expiryField.expirationDate = "122030"
        
        XCTAssertFalse(creditCardForm.isValid)
    }
    
    func testNoFieldValues() {
        XCTAssertFalse(creditCardForm.isValid)
    }
    
    func testCardNumberFieldColorOnInvalid() {
        creditCardForm.cardNumberField.number = "1230193"
        
        XCTAssertEqual(creditCardForm.cardNumberField.backgroundColor, creditCardForm.invalidFieldBGColor)
    }
    
    func testCreditCardScanningDisabled() {
        // Given
        let cardScanningEnabled = false
        
        // When
        creditCardForm.isCardScanningButtonHidden = cardScanningEnabled

        // Then
        XCTAssertFalse(creditCardForm.isCardScanningButtonHidden)
    }

    func testCreditCardScanningDisabledThenEnabled() {
        // Given
        let cardScanningEnabled = true
        creditCardForm.isCardScanningButtonHidden = false
        
        // When
        creditCardForm.isCardScanningButtonHidden = cardScanningEnabled
        
        // Then
        XCTAssertFalse(creditCardForm.isCardScanningButtonHidden)
    }
    
    func testCreditCardScanningSettingEnabled() {
        // Given
        let cardScanningEnabled = true
        
        // When
        creditCardForm.isCardScanningButtonHidden = cardScanningEnabled
        
        // Then
        XCTAssertTrue(creditCardForm.isCardScanningButtonHidden)
    }
}
