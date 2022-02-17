//
//  CreditCardFormComponent.swift
//  CreditCardFormComponent
//
//  Created by Ron on 07/02/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import Foundation
import BraintreeUIKit

public class CreditCardForm: UIView {
    private struct Constants {
        static var fieldHeight: CGFloat = 50
        static var spacing: CGFloat = 8
        static var fieldSpacing: CGFloat = 16
        static var cornerRadius: CGFloat = 5
        static var borderWidth: CGFloat = 1
        static var defaultBGColorOpacity: CGFloat = 0.3
        static var disclosureContainerWidth: CGFloat = 40
    }
    
    var storedAttributedPlaceHolder: NSAttributedString?
    
    private var isEmptyValid: Bool = true
    
    public var validFieldBGColor: UIColor = UIColor.white
    public var validFieldTextColor: UIColor = UIColor.black {
        didSet {
            BTUIKAppearance.sharedInstance().primaryTextColor = validFieldTextColor
        }
    }
    
    public var invalidFieldBGColor: UIColor = UIColor.red.withAlphaComponent(Constants.defaultBGColorOpacity)
    public var invalidFieldTextColor: UIColor = UIColor.red {
        didSet {
            BTUIKAppearance.sharedInstance().errorForegroundColor = invalidFieldTextColor
        }
    }
    
    public var isCardScanningButtonHidden: Bool = false {
        didSet {
            // This fixes the bug on iOS 11 below where hiding
            // the card scan button would also hide the whole numberFieldStackView
            // subviews, so the workaround is just to add and remove manually
            // from the cardScanButton from its stackView
            if isCardScanningButtonHidden {
                numberFieldStackView.removeArrangedSubview(cardScanButton)
                cardScanButton.removeFromSuperview()
            } else {
                if cardScanButton.superview == nil {
                    numberFieldStackView.addArrangedSubview(cardScanButton)
                }
            }
        }
    }
    
    public var isValid: Bool {
        return cardNumberField.valid && expiryField.valid && securityField.valid
    }
    
    public var cardNumber: String? {
        return cardNumberField.number
    }
    
    public var expiryYear: String? {
        return expiryField.expirationYear
    }
    
    public var expiryMonth: String? {
        return expiryField.expirationMonth
    }
    
    public var securityNumber: String? {
        return securityField.securityCode
    }
    
    public var formLineColor: UIColor {
        set {
            BTUIKAppearance.sharedInstance().lineColor = newValue
        }
        get {
            return BTUIKAppearance.sharedInstance().lineColor
        }
    }
    
    public var fieldHeight: CGFloat = Constants.fieldHeight {
        didSet {
            cardNumberFieldHeightConstraint?.constant = fieldHeight
            securityFieldHeightConstraint?.constant = fieldHeight
            expiryFieldHeightConstraint?.constant = fieldHeight
        }
    }
    
    public var fieldSpacing: CGFloat = Constants.fieldSpacing {
        didSet {
            lineViews.forEach { (lineView) in
                lineViewsHeightConstraints[lineView]?.constant = fieldSpacing
            }
        }
    }
    
    public var fieldLineSeparatorColor: UIColor = .clear {
        didSet {
            lineViews.forEach { (lineView) in
                lineView.backgroundColor = fieldLineSeparatorColor
            }
        }
    }
    public var fieldLineInsets: UIEdgeInsets = .zero {
        didSet {
            lineViews.forEach { (lineView) in
                lineViewsLeftAlignConstraints[lineView]?.constant = fieldLineInsets.left
                lineViewsRightAlignConstraints[lineView]?.constant = -fieldLineInsets.right
            }
            mainStackView.spacing = (fieldLineInsets.top + fieldLineInsets.bottom) / 2
        }
    }
    
    public var fieldEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            containerConstraints.forEach { (dict) in
                dict.value[.top]?.constant = fieldEdgeInsets.top
                dict.value[.left]?.constant = fieldEdgeInsets.left
                dict.value[.bottom]?.constant = -fieldEdgeInsets.bottom
                dict.value[.right]?.constant = -fieldEdgeInsets.right
            }
        }
    }
    
    public var fieldMargins: UIEdgeInsets = .zero {
        didSet {
            mainStackViewConstraints[.top]?.constant = fieldMargins.top
            mainStackViewConstraints[.left]?.constant = fieldMargins.left
            mainStackViewConstraints[.right]?.constant = -fieldMargins.bottom
            mainStackViewConstraints[.bottom]?.constant = -fieldMargins.right
        }
    }
    
    var cardNumberFieldHeightConstraint: NSLayoutConstraint?
    var securityFieldHeightConstraint: NSLayoutConstraint?
    var expiryFieldHeightConstraint: NSLayoutConstraint?
    
    public var cardNumberFieldStackViewAxis: NSLayoutConstraint.Axis {
        set {
            numberStackView.axis = newValue
            numberStackView.setNeedsLayout()
        }
        get {
            return numberStackView.axis
        }
    }
    
    public var securityFieldStackViewAxis: NSLayoutConstraint.Axis {
        set {
            securityStackView.axis = newValue
            securityStackView.setNeedsLayout()
        }
        get {
            return securityStackView.axis
        }
    }
    
    public var expiryFieldStackViewAxis: NSLayoutConstraint.Axis {
        set {
            expiryStackView.axis = newValue
            expiryStackView.setNeedsLayout()
        }
        get {
            return expiryStackView.axis
        }
    }
    
    public var cardNumberFieldStackViewSpacing: CGFloat {
        set {
            numberStackView.spacing = newValue
            numberStackView.setNeedsLayout()
        }
        get {
            return numberStackView.spacing
        }
    }
    
    public var securityFieldStackViewSpacing: CGFloat {
        set {
            securityStackView.spacing = newValue
            securityStackView.setNeedsLayout()
        }
        get {
            return securityStackView.spacing
        }
    }
    
    public var expiryFieldStackViewSpacing: CGFloat {
        set {
            expiryStackView.spacing = newValue
            expiryStackView.setNeedsLayout()
        }
        get {
            return expiryStackView.spacing
        }
    }
    
    public var cardNumberStackViewBackgroundColor: UIColor? {
        set {
            numberStackViewContainer.backgroundColor = newValue
        }
        get {
            return numberStackViewContainer.backgroundColor
        }
    }
    
    public var securityStackViewBackgroundColor: UIColor? {
        set {
            securityStackViewContainer.backgroundColor = newValue
        }
        get {
            return securityStackViewContainer.backgroundColor
        }
    }
    
    public var expiryStackViewBackgroundColor: UIColor? {
        set {
            expiryStackViewContainer.backgroundColor = newValue
        }
        get {
            return expiryStackViewContainer.backgroundColor
        }
    }
    
    lazy public private(set) var cardNumberFieldLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Card Number"
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    lazy public private(set) var securityFieldLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "CVV"
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    lazy public private(set) var expiryFieldLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Expiration Date"
        lbl.numberOfLines = 2

        return lbl
    }()

    lazy public private(set) var expiryDisclosureIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    
    lazy public private(set) var expiryIconContainer: UIView = {
        let v = UIView()
        v.addSubview(self.expiryDisclosureIcon)
        self.expiryDisclosureIcon.alignToSuperviewCenterX()
        self.expiryDisclosureIcon.alignToSuperviewCenterY()
        v.constrainTo(width: Constants.disclosureContainerWidth)
        return v
    }()
    
    lazy public private(set) var cardNumberField: GenieCardNumberFormField = {
        let field = GenieCardNumberFormField()
        field.layer.borderWidth = Constants.borderWidth
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = Constants.cornerRadius
        field.clipsToBounds = true
        field.formLabel.isHidden = true
        field.formLabel.text = nil
        field.textField.showDoneAccessory = true
        field.showCardHintAccessory()
        field.delegate = self
        field.textField.adjustsFontSizeToFitWidth = false
        return field
    }()
    
    lazy public private(set) var securityField: GenieSecurityCodeFormField = {
        let field = GenieSecurityCodeFormField()
        field.layer.borderWidth = Constants.borderWidth
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = Constants.cornerRadius
        field.clipsToBounds = true
        field.formLabel.isHidden = true
        field.textField.showDoneAccessory = true
        field.delegate = self
        field.textField.adjustsFontSizeToFitWidth = false

        return field
    }()
    
    lazy public private(set) var expiryField: GenieExpiryFormField = {
        let field = GenieExpiryFormField()
        field.layer.borderWidth = Constants.borderWidth
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = Constants.cornerRadius
        field.clipsToBounds = true
        field.formLabel.isHidden = true
        field.textField.showDoneAccessory = true
        field.delegate = self
        
        return field
    }()
    
    lazy public private(set) var cardScanButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    let numberFieldStackView = UIStackView()
    let numberStackView = UIStackView()
    let numberStackViewContainer = UIView()
    let expiryStackView = UIStackView()
    let expiryStackViewContainer = UIView()
    let securityStackView = UIStackView()
    let securityStackViewContainer = UIView()
    let mainStackView = UIStackView()
    
    private var mainStackViewConstraints: [ConstraintType: NSLayoutConstraint] = [:]
    private func setup() {
        NSLayoutConstraint.activate([
            cardScanButton.widthAnchor.constraint(equalTo: cardScanButton.heightAnchor, multiplier: 1)
        ])
        
        setupNumberStackView()
        setupExpiryStackView()
        setupSecurityStackView()

        setupMainStackView()

        setupConstraints()

        addSubview(mainStackView)
        mainStackViewConstraints[.top] = mainStackView.alignToSuperviewTop()
        mainStackViewConstraints[.left] = mainStackView.alignToSuperviewLeft()
        mainStackViewConstraints[.bottom] = mainStackView.alignToSuperviewBottom()
        mainStackViewConstraints[.right] = mainStackView.alignToSuperviewRight()

        BTUIKAppearance.sharedInstance().errorForegroundColor = invalidFieldTextColor
        BTUIKAppearance.sharedInstance().primaryTextColor = validFieldTextColor
    }
    
    private func setupMainStackView() {
        setupStackView(numberStackView, toContainer: numberStackViewContainer)
        setupStackView(expiryStackView, toContainer: expiryStackViewContainer)
        setupStackView(securityStackView, toContainer: securityStackViewContainer)

        mainStackView.addArrangedSubview(numberStackViewContainer)
        setupLineView()
        mainStackView.addArrangedSubview(expiryStackViewContainer)
        setupLineView()
        mainStackView.addArrangedSubview(securityStackViewContainer)
        mainStackView.axis = .vertical
        mainStackView.spacing = (fieldLineInsets.top + fieldLineInsets.bottom) / 2
    }
    
    private var lineViews: [UIView] = []
    private var lineViewsLeftAlignConstraints: [UIView: NSLayoutConstraint] = [:]
    private var lineViewsRightAlignConstraints: [UIView: NSLayoutConstraint] = [:]
    private var lineViewsHeightConstraints: [UIView: NSLayoutConstraint] = [:]
    private func setupLineView() {
        let lineView = UIView()
        mainStackView.addArrangedSubview(lineView)
        lineViewsLeftAlignConstraints[lineView] = lineView.alignToSuperviewLeft(offset: fieldLineInsets.left)
        lineViewsRightAlignConstraints[lineView] = lineView.alignToSuperviewRight(offset: fieldLineInsets.right)
        lineViewsHeightConstraints[lineView] = lineView.constrainTo(height: Constants.fieldSpacing)
        lineViews.append(lineView)
    }
    
    private var containerConstraints: [UIView: [ConstraintType: NSLayoutConstraint]] = [:]
    private func setupStackView(_ stackView: UIStackView, toContainer container: UIView) {
        container.addSubview(stackView)
        var constraints: [ConstraintType: NSLayoutConstraint] = [:]
        constraints[.top] = stackView.alignToSuperviewTop(offset: fieldEdgeInsets.top)
        constraints[.left] = stackView.alignToSafeAreaLeft(offset: fieldEdgeInsets.left)
        constraints[.bottom] = stackView.alignToSuperviewBottom(offset: -fieldEdgeInsets.bottom)
        constraints[.right] = stackView.alignToSafeAreaRight(offset: -fieldEdgeInsets.right)
        containerConstraints[container] = constraints
    }

    private func setupNumberStackView() {
        numberFieldStackView.addArrangedSubview(cardNumberField)
        numberFieldStackView.addArrangedSubview(cardScanButton)
        numberFieldStackView.axis = .horizontal
        numberFieldStackView.spacing = Constants.fieldSpacing
        
        numberStackView.addArrangedSubview(cardNumberFieldLabel)
        numberStackView.addArrangedSubview(numberFieldStackView)
        numberStackView.spacing = Constants.spacing
        numberStackView.axis = .vertical
    }
    
    private func setupExpiryStackView() {
        expiryStackView.addArrangedSubview(expiryFieldLabel)
        expiryStackView.addArrangedSubview(expiryField)
        expiryStackView.addArrangedSubview(expiryIconContainer)
        
        expiryStackView.spacing = Constants.spacing
        expiryStackView.axis = .vertical
    }
    
    private func setupSecurityStackView() {
        securityStackView.addArrangedSubview(securityFieldLabel)
        securityStackView.addArrangedSubview(securityField)
        securityStackView.spacing = Constants.spacing
        securityStackView.axis = .vertical
    }
    
    private func setupConstraints() {
        cardNumberFieldHeightConstraint = cardNumberField.constrainTo(height: fieldHeight)
        securityFieldHeightConstraint = securityField.constrainTo(height: fieldHeight)
        expiryFieldHeightConstraint = expiryField.constrainTo(height: fieldHeight)
    }
    
    public func validate() {
        cardNumberField.validate()
        expiryField.validate()
        securityField.validate()
    }
    
    public func invalidateEmptyFields() {
        isEmptyValid = false
        validate()
        isEmptyValid = true
    }
}

extension CreditCardForm: BTUIKFormFieldDelegate {
    func updateDisplayColor(for formField: BTUIKFormField, isValid: Bool) {
        if isValid {
            formField.textField.textColor = BTUIKAppearance.sharedInstance().primaryTextColor
            formField.backgroundColor = validFieldBGColor
        } else {
            formField.textField.textColor = BTUIKAppearance.sharedInstance().errorForegroundColor
            formField.backgroundColor = invalidFieldBGColor
        }
    }
    
    public func formFieldDidBeginEditing(_ formField: BTUIKFormField!) {
        formField.displayAsValid = true
        
        storedAttributedPlaceHolder = formField?.textField.attributedPlaceholder
        formField.textField.attributedPlaceholder = NSAttributedString()
        
        updateDisplayColor(for: formField, isValid: (formField.displayAsValid || (formField.text.isEmpty && isEmptyValid)))
    }
    
    public func formFieldDidChange(_ formField: BTUIKFormField!) {
        updateDisplayColor(for: formField, isValid: (formField.displayAsValid || (formField.text.isEmpty && isEmptyValid)))
    }

    public func formFieldDidEndEditing(_ formField: BTUIKFormField!) {
        let isValid = formField.valid || (formField.text.isEmpty && isEmptyValid)

        formField.displayAsValid = isValid
        updateDisplayColor(for: formField, isValid: isValid)
        
        if formField.text.isEmpty {
            formField.textField.attributedPlaceholder = storedAttributedPlaceHolder
        }
    }
}
