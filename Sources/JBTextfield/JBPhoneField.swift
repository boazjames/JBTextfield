//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import UIKit

public class BasePhoneField: UIView {
    var isDeleting = false
    
    @IBInspectable public var maxLength = 12
    
    var labelHeightConstraint: NSLayoutConstraint!
    var countryCodeConstraint: NSLayoutConstraint!
    
    @IBInspectable public var labelText = "phone_no".localized
    @IBInspectable public var placehodler = "phone_no".localized
    
    @IBInspectable public var boxBackgroundColor: UIColor = UIColor.textFieldBackgroundColor {
        didSet {
            mainContainerView.backgroundColor = boxBackgroundColor
        }
    }
    
    @IBInspectable public var boxCornerRadius: CGFloat = 5 {
        didSet {
            mainContainerView.jbViewCornerRadius = boxCornerRadius
        }
    }
    
    @IBInspectable public var boxBorderWidth: CGFloat = 1 {
        didSet {
            mainContainerView.jbBorderWidth = boxBorderWidth
        }
    }
    
    @IBInspectable public var boxBorderColor: UIColor = UIColor.strokeColor {
        didSet {
            mainContainerView.jbBorderColor = boxBorderColor
        }
    }
    
    public var text: String {
        return textfield.text ?? ""
    }
    
    public var isEmpty: Bool {
        return text.isEmpty
    }
    
    public var isBlank: Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @IBInspectable public var placeholderColor: UIColor = UIColor.placeholderColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.labelColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var labelColor: UIColor = UIColor.labelColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var strokeColor: UIColor = UIColor.strokeColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var errorColor: UIColor = UIColor.errorColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var highlightColor: UIColor = UIColor.highlightColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var labelFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            label.font = labelFont
        }
    }
    
    @IBInspectable public var textfieldFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            textfield.font = textfieldFont
        }
    }
    
    @IBInspectable public var errorLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            lblError.font = errorLabelFont
        }
    }
    
    @IBInspectable public var countryCodeLabelFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            lblCountryCode.font = countryCodeLabelFont
        }
    }
    
    var errorText: String {
        return lblError.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    var isErrorTextEmpty: Bool {
        return errorText.isEmpty
    }
    
    public var customDialCodes = [String]()
    public var selectedCountry = JBCountry(name: "Kenya", code: "KE", dialCode: "254")
    var selectedCountryCode = "254"
    
    public var fullPhoneNo: String {
        var phoneNo = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let dialCode = selectedCountry.dialCode
        
        if phoneNo.starts(with: "0") {
            phoneNo.removeFirst()
            
            return "\(dialCode)\(phoneNo)"
        }
        
        if phoneNo.count > 10 && phoneNo.starts(with: dialCode) {
            phoneNo = String(phoneNo.suffix(phoneNo.count - dialCode.count))
        }
        
        return "\(dialCode)\(phoneNo)"
    }
    
    public var fullPhoneNoWithPlus: String {
        return "+\(fullPhoneNo)"
    }
    
    public var delegate: JBTextFieldDelegate?
    
    var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.jbBorderWidth = 1
        view.jbViewCornerRadius = 5
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var countryCodeContainer: UIView =  {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
    
        return view
    }()
    
    var flagImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "ke", in: .module, compatibleWith: nil)
        return imgView
    }()
    
    var contactImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "contact")
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    var lblCountryCode: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "KE"
        return lbl
    }()
    
    var icPicker: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "chevron_down", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        return imgView
    }()
    
    var phoneFieldContainer: UIView =  {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
    
        return view
    }()
    
    public var textfield: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .labelColor
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.textPadding = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 10)
        textField.layer.cornerRadius = 5
        textField.textContentType = .telephoneNumber
        return textField
    }()
    
    var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        return view
    }()
    
    var lblError: PaddingLabel = {
        let view = PaddingLabel()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 0
        view.leftInset = 0
        view.rightInset = 0
        view.topInset = 0
        view.bottomInset = 0
        view.labelCornerRadius = 0
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        setCountry(selectedCountry)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        
        setCountry(selectedCountry)
    }
    
    func setupView() {
        mainContainerView.backgroundColor = boxBackgroundColor
        label.font = labelFont
        textfield.font = textfieldFont
        lblError.font = errorLabelFont
        lblCountryCode.font = countryCodeLabelFont
        separatorView.backgroundColor = strokeColor
        
        setupColors()
        
        setPlaceholder(placehodler)
        
        textfield.addDoneButtonOnKeyboard(color: .highlightColor)
        
        countryCodeContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryPicker)))
        mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focusTextField)))
        textfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    public func setPlaceholder(_ placeholder: String) {
        self.placehodler = placeholder
        self.labelText = placeholder
        textfield.placeholder = placeholder
        label.text = labelText
    }
    
    public func setPlaceholder(_ placeholder: String, labelText: String) {
        self.placehodler = placeholder
        self.labelText = labelText
        textfield.placeholder = placeholder
        label.text = labelText
    }
    
    public func setCountry(_ country: JBCountry) {
        selectedCountry = country
        selectedCountryCode = country.dialCode
        flagImg.image = UIImage(named: country.code.lowercased(), in: .module, compatibleWith: nil)
        lblCountryCode.text = country.code
        countryCodeConstraint.constant = lblCountryCode.intrinsicContentSize.width
    }
    
    public func setCountry(_ dialCode: String) {
        guard let path = Bundle.module.path(forResource: "countries", ofType: "json") else { return }
        let jsonString = (try? String(contentsOfFile: path, encoding: String.Encoding.utf8)) ?? ""
        let data = Data(jsonString.utf8)
        let countries = (try? JSONDecoder().decode([JBCountry].self, from: data)) ?? []
        
        if let country = countries.first(where: { $0.dialCode == dialCode }) {
            selectedCountry = country
            selectedCountryCode = country.dialCode
            flagImg.image = UIImage(named: country.code.lowercased(), in: .module, compatibleWith: nil)
            lblCountryCode.text = country.code
            countryCodeConstraint.constant = lblCountryCode.intrinsicContentSize.width
        }
    }
    
    func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            separatorView.backgroundColor = textfield.isFirstResponder ? highlightColor : strokeColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            mainContainerView.jbBorderColor = errorColor
            separatorView.backgroundColor = errorColor
            label.textColor = errorColor
        }
        
        label.textColor = labelColor
        lblError.textColor = errorColor
        lblCountryCode.textColor = labelColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
        icPicker.tintColor = labelColor
    }
    
    @objc private func focusTextField() {
        textfield.becomeFirstResponder()
    }
    
    @objc private func unFocusTextField() {
        textfield.resignFirstResponder()
    }
    
    @objc public func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        let myText = text.onlyDigits()
        
        if myText != text {
            sender.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
    
    public func showError(_ message: String, focusOnField: Bool = false) {
        lblError.text = message
        
        if focusOnField {
            textfield.becomeFirstResponder()
        }
        
        mainContainerView.jbBorderColor = errorColor
        label.textColor = errorColor
        separatorView.backgroundColor = errorColor
    }
    
    public func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
        separatorView.backgroundColor = textfield.isFirstResponder ? highlightColor : strokeColor
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    @objc private func showCountryPicker() {
        let vc = CountryPickerVC()
        vc.selectedCountryCode = selectedCountryCode
        vc.customDialCodes = customDialCodes
        vc.textfield = self
        let nc = UINavigationController(rootViewController: vc)
        findViewController()?.present(nc, animated: true)
    }
    
    public static func showCountryPicker(viewController: UIViewController, selectedCountryCode: String?, customDialCodes: [String], completion: @escaping (_ country: JBCountry, _ flag: UIImage?) -> Void) {
        let vc = CountryPickerVC()
        vc.selectedCountryCode = selectedCountryCode
        vc.customDialCodes = customDialCodes
        vc.completion = completion
        let nc = UINavigationController(rootViewController: vc)
        viewController.present(nc, animated: true)
    }
    
    public static func getCountryDetails(countryCode: String) -> (country: JBCountry, flag: UIImage?)? {
        guard let path = Bundle.module.path(forResource: "countries", ofType: "json") else { return nil }
        let jsonString = (try? String(contentsOfFile: path, encoding: String.Encoding.utf8)) ?? ""
        let data = Data(jsonString.utf8)
        let countries = (try? JSONDecoder().decode([JBCountry].self, from: data)) ?? []
        
        if let country = countries.filter({ $0.code.equalsIgnoringCase(countryCode) || $0.dialCode.equalsIgnoringCase(countryCode) }).first {
            return (country: country, UIImage(named: country.code.lowercased(), in: .module, compatibleWith: nil))
        }
        
        return nil
    }
}

public class JBPhoneField: BasePhoneField {
    
    override func setupView() {
        super.setupView()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(countryCodeContainer)
        countryCodeContainer.addSubview(flagImg)
        countryCodeContainer.addSubview(lblCountryCode)
        countryCodeContainer.addSubview(icPicker)
        containerView.addSubview(textfield)
        containerView.addSubview(label)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        NSLayoutConstraint.activate([
            countryCodeContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            countryCodeContainer.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            countryCodeContainer.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
        
        flagImg.applyAspectRatio(aspectRation: 3 / 2)
        
        NSLayoutConstraint.activate([
            flagImg.widthAnchor.constraint(equalToConstant: 30),
            flagImg.leadingAnchor.constraint(equalTo: countryCodeContainer.leadingAnchor, constant: 0),
            flagImg.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor)
        ])
        
        countryCodeConstraint = lblCountryCode.widthAnchor.constraint(equalToConstant: lblCountryCode.intrinsicContentSize.width)
        countryCodeConstraint.activate()
        
        NSLayoutConstraint.activate([
            lblCountryCode.leadingAnchor.constraint(equalTo: flagImg.trailingAnchor, constant: 8),
            lblCountryCode.trailingAnchor.constraint(equalTo: icPicker.leadingAnchor, constant: -5),
            lblCountryCode.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            icPicker.widthAnchor.constraint(equalToConstant: 12),
            icPicker.heightAnchor.constraint(equalToConstant: 12),
            icPicker.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor),
            icPicker.trailingAnchor.constraint(equalTo: countryCodeContainer.trailingAnchor, constant: 0)
        ])
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: textfield.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10),
            labelHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            textfield.leadingAnchor.constraint(equalTo: countryCodeContainer.trailingAnchor, constant: 10),
            textfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfield.topAnchor.constraint(equalTo: label.centerYAnchor),
            textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        textfield.delegate = self
    }
    
    private func showLabel() {
        self.layoutIfNeeded()
        let originY = label.frame.origin.y
        let distance: CGFloat = 20
        label.frame.origin.y = originY + distance
        
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.deactivate()
            self.label.frame.origin.y = originY
            self.layoutIfNeeded()
        }
    }
    
    private func hideLabel() {
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.activate()
            self.layoutIfNeeded()
        }
    }
    
    public func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
            label.textColor = .secondaryLabelColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            textfield.text = text
            label.textColor = .labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
    }
}

// Mark: UITextFieldDelegate
extension JBPhoneField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        label.textColor = isErrorTextEmpty ? highlightColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? highlightColor : errorColor
        if let text = textField.text {
            if text.isEmpty {
                showLabel()
            }
        } else {
            showLabel()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        label.textColor = isErrorTextEmpty ? labelColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? strokeColor : errorColor
        
        if let text = textField.text {
            if text.isEmpty {
                hideLabel()
            }
        } else {
            hideLabel()
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        var fullText: String {
            if string.isEmpty {
                var text = currentText
                guard let myRange = Range(range, in: currentText) else { return text}
                text.replaceSubrange(myRange, with: string)
                
                return text
            }
            
            return "\(currentText)\(string)"
        }
        
        if fullText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        
        let myFullText = fullText.onlyDigits()
        
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}

public class JBStackedPhoneField: BasePhoneField {
    override func setupView() {
        super.setupView()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        mainContainerView.addSubview(countryCodeContainer)
        countryCodeContainer.addSubview(flagImg)
        countryCodeContainer.addSubview(lblCountryCode)
        countryCodeContainer.addSubview(icPicker)
        mainContainerView.addSubview(separatorView)
        mainContainerView.addSubview(textfield)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        
        NSLayoutConstraint.activate([
            countryCodeContainer.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 15),
            countryCodeContainer.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -15),
            countryCodeContainer.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            countryCodeContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        flagImg.applyAspectRatio(aspectRation: 3 / 2)
        
        NSLayoutConstraint.activate([
            flagImg.widthAnchor.constraint(equalToConstant: 30),
            flagImg.leadingAnchor.constraint(equalTo: countryCodeContainer.leadingAnchor, constant: 0),
            flagImg.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor)
        ])
        
        countryCodeConstraint = lblCountryCode.widthAnchor.constraint(equalToConstant: lblCountryCode.intrinsicContentSize.width)
        
        NSLayoutConstraint.activate([
            lblCountryCode.leadingAnchor.constraint(equalTo: flagImg.trailingAnchor, constant: 10),
            lblCountryCode.trailingAnchor.constraint(equalTo: icPicker.leadingAnchor, constant: -10),
            lblCountryCode.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            icPicker.widthAnchor.constraint(equalToConstant: 12),
            icPicker.heightAnchor.constraint(equalToConstant: 12),
            icPicker.centerYAnchor.constraint(equalTo: countryCodeContainer.centerYAnchor),
            icPicker.trailingAnchor.constraint(equalTo: countryCodeContainer.trailingAnchor, constant: 0)
        ])
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: countryCodeContainer.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            textfield.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            textfield.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 50),
            textfield.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            textfield.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        textfield.delegate = self
    }
    
    public override func setCountry(_ country: JBCountry) {
        super.setCountry(country)
        
        lblCountryCode.text = "\(country.name) (+\(country.dialCode))"
    }
    
    public override func setCountry(_ dialCode: String) {
        super.setCountry(dialCode)
        
        lblCountryCode.text = "\(selectedCountry.name) (+\(selectedCountry.dialCode))"
    }
    
    public func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
            label.textColor = .secondaryLabelColor
        } else {
            textfield.text = text
            label.textColor = .labelColor
        }
    }
}

// Mark: UITextFieldDelegate
extension JBStackedPhoneField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        mainContainerView.jbBorderColor = isErrorTextEmpty ? highlightColor : errorColor
        separatorView.backgroundColor = isErrorTextEmpty ? highlightColor : errorColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        mainContainerView.jbBorderColor = isErrorTextEmpty ? strokeColor : errorColor
        separatorView.backgroundColor = isErrorTextEmpty ? strokeColor : errorColor
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        var fullText: String {
            if string.isEmpty {
                var text = currentText
                guard let myRange = Range(range, in: currentText) else { return text}
                text.replaceSubrange(myRange, with: string)
                
                return text
            }
            
            return "\(currentText)\(string)"
        }
        
        if fullText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        
        let myFullText = fullText.onlyDigits()
        
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}
