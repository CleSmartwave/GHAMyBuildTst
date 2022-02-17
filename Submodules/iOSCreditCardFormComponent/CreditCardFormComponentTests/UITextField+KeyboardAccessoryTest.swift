//
//  UITextField+KeyboardAccessoryTest.swift
//  CreditCardFormComponentTests
//
//  Created by Ron on 08/02/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import XCTest
@testable import CreditCardFormComponent

class UITextField_KeyboardAccessoryTest: XCTestCase {
    
    var textField: UITextField!
    
    override func setUp() {
        super.setUp()
        
        textField = UITextField()
    }
    
    func testHasDoneAccessory() {
        textField.showDoneAccessory = true
        
        XCTAssertNotNil(textField.inputAccessoryView)
    }
    
    func testRemoveDoneAccessory() {
        textField.showDoneAccessory = true
        textField.showDoneAccessory = false
        
        XCTAssertNil(textField.inputAccessoryView)
    }
}
