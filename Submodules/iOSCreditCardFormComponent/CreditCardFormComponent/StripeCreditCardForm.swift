//
//  StripeCardNumberFormField.swift
//  CreditCardFormComponent
//
//  Created by Pat Osorio on 9/26/19.
//  Copyright © 2019 genie. All rights reserved.
//

import Foundation
import Stripe

public class StripeCreditCardForm: UIView {
    
    enum CreditCardFields: Int {
        case CardNumber = 1
        case Security = 2
        case ExpirationDate = 3
    }
    
    struct Constants {
        static let fieldHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let spacing: CGFloat = 8
        static let defaultBGColorOpacity: CGFloat = 0.3
        static let fieldSpacing: CGFloat = 16
        static let disclosureContainerWidth: CGFloat = 40
        static let brandImageSize = CGSize(width: 35, height: 20)
        static let brandImageContainerSize: CGFloat = 60
        static let expiryYears: Int = 20
        static let expiryMonths: Int = 12
    }
    
    var cardBrand: STPCardBrand = STPCardBrand.unknown
    
    private var pickerData: [[String]] = [[]]
    private var pickerMonth: String = String(Date().month)
    private var pickerYear: String = String(Date().year)
    
    private var isEmptyValid: Bool = true
    
    public var validFieldBGColor: UIColor = .white
    public var validFieldTextColor: UIColor = .black
    
    public var invalidFieldBGColor: UIColor = UIColor.red.withAlphaComponent(Constants.defaultBGColorOpacity)
    public var invalidFieldTextColor: UIColor = .red
    
    private var lineViews: [UIView] = []
    private var lineViewsLeftAlignConstraints: [UIView: NSLayoutConstraint] = [:]
    private var lineViewsRightAlignConstraints: [UIView: NSLayoutConstraint] = [:]
    private var lineViewsHeightConstraints: [UIView: NSLayoutConstraint] = [:]
    
    private var containerConstraints: [UIView: [ConstraintType: NSLayoutConstraint]] = [:]

    lazy fileprivate(set) var brandImageContainer: UIView = {
        let v = UIView()
        v.addSubview(self.brandImage)
        self.brandImage.alignToSuperviewCenterX()
        self.brandImage.alignToSuperviewCenterY()
        v.constrainTo(width: Constants.brandImageContainerSize)
        return v
    }()
    
    lazy fileprivate(set) var brandImage: UIImageView = {
        let v = UIImageView()
        v.constrainTo(size: Constants.brandImageSize)
        v.contentMode = .scaleAspectFit
        v.image = STPImageLibrary.brandImage(for: cardBrand)
        
        v.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        v.setContentHuggingPriority(.defaultLow, for: .vertical)
        return v
    }()
    
    lazy public private(set) var cardNumberFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Card Number"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy public private(set) var securityFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "CVV"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy public private(set) var expiryFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Expiration Date"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy public private(set) var cardNumberField: StripeCardNumberFormField = {
        let textField = StripeCardNumberFormField()
        textField.delegate = self
        textField.tag = CreditCardFields.CardNumber.rawValue
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.clipsToBounds = true
        textField.adjustsFontSizeToFitWidth = false
        
        textField.addTarget(self, action: #selector(textEditDidChange(_:)), for: .editingChanged)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy public private(set) var securityField: StripeSecurityCodeFormField = {
        let textField = StripeSecurityCodeFormField()
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.clipsToBounds = true
        textField.delegate = self
        textField.adjustsFontSizeToFitWidth = false
        textField.tag = CreditCardFields.Security.rawValue
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.addTarget(self, action: #selector(cvcDidChange(_:)), for: .editingChanged)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy public private(set) var expiryField: StripeExpiryFormField = {
        let textField = StripeExpiryFormField()
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.clipsToBounds = true
        textField.delegate = self
        textField.adjustsFontSizeToFitWidth = false
        textField.tag = CreditCardFields.ExpirationDate.rawValue
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(expirationDateDidChange(textField:)), for: .editingChanged)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.inputView = datePicker
        return textField
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
    
    lazy fileprivate(set) var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    let numberStackViewContainer = UIView()
    lazy fileprivate(set) var numberFieldStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.fieldSpacing
        return stack
    }()
    
    lazy fileprivate(set) var numberStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        return stack
    }()
    
    var expiryStackViewContainer = UIView()
    lazy fileprivate(set) var expiryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        return stack
    }()
    
    var securityStackViewContainer = UIView()
    lazy fileprivate(set) var securityStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        return stack
    }()
    
    lazy fileprivate(set) var datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        createPickerContent(willRestrictMonth: true)
        
        numberStackView.addArrangedSubview(cardNumberFieldLabel)
        numberStackView.addArrangedSubview(cardNumberField)
        numberStackView.addArrangedSubview(brandImageContainer)
        
        expiryStackView.addArrangedSubview(expiryFieldLabel)
        expiryStackView.addArrangedSubview(expiryField)
        expiryStackView.addArrangedSubview(expiryIconContainer)
        
        securityStackView.addArrangedSubview(securityFieldLabel)
        securityStackView.addArrangedSubview(securityField)
        
        setupMainStackView()
        
        cardNumberField.constrainTo(height: fieldHeight)
        securityField.constrainTo(height: fieldHeight)
        expiryField.constrainTo(height: fieldHeight)
        
        addSubview(mainStackView)
        mainStackView.alignToSuperviewTop()
        mainStackView.alignToSuperviewBottom()
        mainStackView.alignToSuperviewRight()
        mainStackView.alignToSuperviewLeft()
    }
    
    private func setupLineView() {
        let lineView = UIView()
        mainStackView.addArrangedSubview(lineView)
        lineViewsLeftAlignConstraints[lineView] = lineView.alignToSuperviewLeft(offset: fieldLineInsets.left)
        lineViewsRightAlignConstraints[lineView] = lineView.alignToSuperviewRight(offset: fieldLineInsets.right)
        lineViewsHeightConstraints[lineView] = lineView.constrainTo(height: Constants.fieldSpacing)
        lineViews.append(lineView)
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
    
    private func setupStackView(_ stackView: UIStackView, toContainer container: UIView) {
        container.addSubview(stackView)
        var constraints: [ConstraintType: NSLayoutConstraint] = [:]
        constraints[.top] = stackView.alignToSuperviewTop(offset: fieldEdgeInsets.top)
        constraints[.left] = stackView.alignToSafeAreaLeft(offset: fieldEdgeInsets.left)
        constraints[.bottom] = stackView.alignToSuperviewBottom(offset: -fieldEdgeInsets.bottom)
        constraints[.right] = stackView.alignToSafeAreaRight(offset: -fieldEdgeInsets.right)
        containerConstraints[container] = constraints
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
    
    public var fieldHeight: CGFloat = Constants.fieldHeight {
        didSet {
            cardNumberField.constrainTo(height: fieldHeight)
            securityField.constrainTo(height: fieldHeight)
            expiryField.constrainTo(height: fieldHeight)
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
            mainStackView.alignToSuperviewTop(offset: fieldMargins.top)
            mainStackView.alignToSuperviewBottom(offset: fieldMargins.left)
            mainStackView.alignToSuperviewRight(offset: -fieldMargins.bottom)
            mainStackView.alignToSuperviewLeft(offset: -fieldMargins.right)
        }
    }
    
    public var isValid: Bool {
        
        return cardNumberField.isValid && expiryField.isValid && securityField.isValid(forCardBrand: cardBrand)
    }
    
    public func validateCreditCardDetails() {
        textFieldDidEndEditing(cardNumberField)
        textFieldDidEndEditing(expiryField)
        textFieldDidEndEditing(securityField)
    }
    
    public func invalidateEmptyFields() {
        isEmptyValid = false
        validateCreditCardDetails()
        isEmptyValid = true
    }
}

// MARK: Getter Setters
extension StripeCreditCardForm {
    public var cardNumber: String? {
        return cardNumberField.text
    }
    
    public var expiryYear: String? {
        return expiryField.expiryYear
    }
    
    public var expiryMonth: String? {
        return expiryField.expiryMonth
    }
    
    public var securityNumber: String? {
        return securityField.text
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
}

// MARK: Handlers
extension StripeCreditCardForm {
    @objc func cvcDidChange(_ textField: UITextField) {
        guard let cardNo = textField.text else { return }
        if cardNo.count > STPCardValidator.maxCVCLength(for: cardBrand) {
            textField.deleteBackward()
        }
    }
    
    @objc func expirationDateDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        
        if STPCardValidator.validationState(forExpirationYear: String(text.suffix(2)),
                                            inMonth: String(text.prefix(2))).rawValue == 1
                                                || text.count < 7 {
            textField.textColor = invalidFieldTextColor
            textField.backgroundColor = invalidFieldBGColor
        } else {
            textField.textColor = validFieldTextColor
            textField.backgroundColor = validFieldBGColor
        }
        
        //automatic add slash
        if text.hasSuffix("/") {
            // do nothing
        } else if text.count == 3 {
            let sIndex = text.index(text.startIndex, offsetBy: 2)
            textField.text?.insert("/", at: sIndex)
        }
        
        if text.count > 7 {
            textField.deleteBackward()
        }
    }
    
    @objc func textEditDidChange(_ textField: UITextField) {
        if textField.tag == CreditCardFields.CardNumber.rawValue {
            guard let text = textField.text else { return }
            
            textField.text = modifyCreditCardString(text)
            
            let addSpace = STPCardBrand.amex == cardBrand ? 2 : 3
            let maxLength = STPCardValidator.maxLength(for: cardBrand) + addSpace
            if let updatedText = textField.text, updatedText.count > maxLength {
                textField.deleteBackward()
            }
        }
    }
    
    public func modifyCreditCardString(_ creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if !arrOfCharacters.isEmpty {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if cardBrand == STPCardBrand.amex {
                    if i > 5 {
                        if ((i+1) % 9 == 0 && i+1 != arrOfCharacters.count) {
                            modifiedCreditCardString.append(" ")
                        }
                    } else if ((i+1) % 4 == 0 && i+1 != arrOfCharacters.count) {
                        modifiedCreditCardString.append(" ")
                    }
                } else {
                    if ((i+1) % 4 == 0 && i+1 != arrOfCharacters.count) {
                        modifiedCreditCardString.append(" ")
                    }
                }
            }
        }
        setCardBrandImage(cardNumber: creditCardString)
        checkCardNumberValidity()
        return modifiedCreditCardString
    }
    
    func checkCardNumberValidity() {
        if cardNumberField.isValid {
            cardNumberField.textColor = validFieldTextColor
            cardNumberField.backgroundColor = validFieldBGColor
        } else {
            cardNumberField.textColor = invalidFieldTextColor
            cardNumberField.backgroundColor = invalidFieldBGColor
        }
    }
    
    func setCardBrandImage(cardNumber: String) {
        cardBrand = STPCardValidator.brand(forNumber: cardNumber)
        let image = STPImageLibrary.brandImage(for: cardBrand)
        brandImage.image = image
    }
    
    func createPickerContent(willRestrictMonth restrict: Bool) {
        let date = Date()
        
        let initialMonth = restrict ? date.month : 1
        
        var arrayMonths: [String] = []
        for i in initialMonth...Constants.expiryMonths {
            arrayMonths.append(String(format: "%02d", i))
        }
        
        var arrayYears: [String] = []
        for i in 0...Constants.expiryYears {
            arrayYears.append(String(date.year + i))
        }
        
        pickerData = [arrayMonths, arrayYears]
    }
}

extension StripeCreditCardForm: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == CreditCardFields.Security.rawValue {
            brandImage.image = STPImageLibrary.cvcImage(for: cardBrand)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        endEditing(true)
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let number = textField.text else { return }
        if textField.tag == CreditCardFields.CardNumber.rawValue {
            setCardBrandImage(cardNumber: number)
        } else {
            setCardBrandImage(cardNumber: cardNumberField.text ?? "")
        }
    }
}

extension StripeCreditCardForm: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerMonth = pickerData[component][row]
        }
        if component == 1 {
            pickerYear = pickerData[component][row]
            createPickerContent(willRestrictMonth: (Int(pickerYear) ?? 0) == Date().year)
            pickerView.reloadComponent(0)
        }
        expiryField.text = pickerMonth + "/" + pickerYear
        expirationDateDidChange(textField: expiryField)
    }
}
