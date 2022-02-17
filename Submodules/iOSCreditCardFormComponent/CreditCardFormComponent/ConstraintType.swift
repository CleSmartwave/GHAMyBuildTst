//
//  ConstraintType.swift
//  CreditCardFormComponent
//
//  Created by user1 on 21/06/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import Foundation
import UIKit

enum ConstraintType: Int {
    case top = 0
    case left = 1
    case bottom = 2
    case right = 3
    
    static var allSides: [ConstraintType] = [.top, .left, .bottom, .right]
}
