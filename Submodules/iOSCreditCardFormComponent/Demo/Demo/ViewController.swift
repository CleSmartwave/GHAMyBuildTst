//
//  ViewController.swift
//  Demo
//
//  Created by Ron on 07/02/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import UIKit
import BraintreeUIKit
import CreditCardFormComponent
import GenieCoreFoundation

class ViewController: UIViewController {
    
    let indentation: CGFloat = 24
    
    let cardForm = CreditCardForm()

    let stripeCardForm = StripeCreditCardForm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStripeForm()
    }
    
    func setupStripeForm() {
        view.addSubview(stripeCardForm)
        
        stripeCardForm.validFieldBGColor = .clear
        stripeCardForm.invalidFieldBGColor = .clear
        
        stripeCardForm.fillSuperviewWidth()
        stripeCardForm.alignToSafeAreaTop()
//        stripeCardForm.fillSuperviewHeight()
        stripeCardForm.fieldHeight = 80
        
    }
    
    func setupBraintreeForm() {
        view.addSubview(cardForm)
        
        cardForm.validFieldBGColor = .clear
        cardForm.invalidFieldBGColor = .clear
        
        cardForm.cardNumberField.number = "5123456789"
        cardForm.validate()
        cardForm.fillSuperviewWidth(offset: 0)
        cardForm.alignToSafeAreaTop()
        
        cardForm.cardNumberFieldStackViewAxis = .horizontal
        cardForm.securityFieldStackViewAxis = .horizontal
        
        cardForm.cardNumberFieldLabel.constrainTo(width: 120)
        cardForm.securityFieldLabel.constrainTo(width: 120)
        
        let field = cardForm.cardNumberField
        let layer = field.layer
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        layer.cornerRadius = 4
        
        cardForm.cardNumberStackViewBackgroundColor = .lightGray
        cardForm.securityStackViewBackgroundColor = .lightGray
        cardForm.expiryStackViewBackgroundColor = .lightGray
        
        cardForm.fieldHeight = 80
        cardForm.fieldSpacing = 1
        cardForm.fieldEdgeInsets = UIEdgeInsets(top: 8, left: indentation, bottom: 8, right: 10)
        cardForm.fieldMargins = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        
        cardForm.backgroundColor = .black
        
        cardForm.isCardScanningButtonHidden = true
        
        cardForm.fieldLineSeparatorColor = .lightGray
        
        cardForm.formLineColor = .clear
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var right: CGFloat = cardForm.bounds.width - indentation
        if #available(iOS 11.0, *) {
            right -= cardForm.safeAreaLayoutGuide.layoutFrame.origin.x
        }
        cardForm.fieldLineInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: right)
    }
}
