import UIKit

@objc public protocol JBTextFieldDelegate {
    @objc optional func textDidChange(textField: UITextField)
}

@IBDesignable
public class BaseTextfield: UIView {
    var isDeleting = false
    
    @IBInspectable public var maxLength = 0
    
    var labelHeightConstraint: NSLayoutConstraint!
    @IBInspectable public var labelText = ""
    @IBInspectable public var placehodler = ""
    
    public var text: String {
        return textfield.text ?? ""
    }
    
    public var numericValue: Double {
        return textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).doubleValue() ?? 0
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
    
    @IBInspectable public var keyboardType: UIKeyboardType = UIKeyboardType.default {
        didSet {
            if !(self is JBCreditCardTextfield) && !(self is JBAmountTextfield) {
                textfield.keyboardType = keyboardType
                setText(text)
            }
        }
    }
    
    @IBInspectable public var textContentType: UITextContentType? {
        didSet {
            if !(self is JBCreditCardTextfield) {
                textfield.textContentType = textContentType
                setText(text)
            }
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
    
    @IBInspectable public var secondaryLabelFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            secondaryLabel.font = secondaryLabelFont
        }
    }
    
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
    
    var errorText: String {
        return lblError.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    var isErrorTextEmpty: Bool {
        return errorText.isEmpty
    }
    
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
    
    var label: PaddingLabel = {
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
    
    var secondaryLabel: PaddingLabel = {
        let view = PaddingLabel()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 0
        view.leftInset = 0
        view.rightInset = 0
        view.topInset = 0
        view.bottomInset = 0
        return view
    }()
    
    public var textfield: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return textField
    }()
    
    var icon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .labelColor
        view.contentMode = .scaleAspectFill
        view.applyAspectRatio(aspectRation: 1)
        return view
    }()
    
    @IBInspectable public var iconImage: UIImage? {
        didSet {
            if icon.superview != nil {
                icon.image = iconImage?.withRenderingMode(.alwaysTemplate)
                icon.isHidden = iconImage == nil
                if self is JBAmountTextfield {
                    textfield.textPadding = UIEdgeInsets(top: 0, left: iconImage == nil ? 50 : 80, bottom: 0, right: 10)
                    labelLeadingConstraint.constant = iconImage == nil ? 0 : 30
                    secondaryLabelLeadingConstraint?.constant = iconImage == nil ? 10 : 40
                } else if self is JBPasswordField {
                    textfield.textPadding = UIEdgeInsets(top: 0, left: iconImage == nil ? 10 : 40, bottom: 0, right: 40)
                    labelLeadingConstraint.constant = iconImage == nil ? 0 : 40
                } else {
                    textfield.textPadding = UIEdgeInsets(top: 0, left: iconImage == nil ? 10 : 40, bottom: 0, right: 10)
                    labelLeadingConstraint.constant = iconImage == nil ? 10 : 40
                }
            }
        }
    }
    
    public var delegate: JBTextFieldDelegate?
    
    var labelLeadingConstraint: NSLayoutConstraint!
    var secondaryLabelLeadingConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        setupColors()
        
        label.font = labelFont
        secondaryLabel.font = secondaryLabelFont
        textfield.font = textfieldFont
        lblError.font = errorLabelFont
        mainContainerView.backgroundColor = boxBackgroundColor
        
//        textfield.addDoneButtonOnKeyboard(color: highlightColor)
        
        mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focusTextField)))
        textfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    public func setPlaceholder(_ placeholder: String) {
        self.placehodler = placeholder
    }
    
    public func setPlaceholder(_ placeholder: String, labelText: String) {
        self.placehodler = placeholder
        self.labelText = labelText
    }
    
    public func setText(_ text: String) {}
    
    public func showError(_ message: String, focusOnField: Bool = false) {}
    
    public func hideError() {}
    
    @objc private func focusTextField() {
        textfield.becomeFirstResponder()
    }
    
    @objc private func unFocusTextField() {
        textfield.resignFirstResponder()
    }
    
    @objc public func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        var myText: String {
            if textfield.keyboardType == .numberPad {
                return text.onlyDigits()
            }
            
            return text
        }
        
        if myText != text {
            sender.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
    
    func setupColors() {}
}

@IBDesignable
public class JBTextfield: BaseTextfield {
    
    override func setupView() {
        super.setupView()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = keyboardType
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(textfield)
        containerView.addSubview(label)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            labelLeadingConstraint,
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            labelHeightConstraint
        ])
        
        icon.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        textfield.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfield.topAnchor.constraint(equalTo: label.centerYAnchor),
            textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
        label.text = placeholder
    }
    
    public override func setPlaceholder(_ placeholder: String, labelText: String) {
        super.setPlaceholder(placeholder, labelText: labelText)
        textfield.placeholder = placeholder
        label.text = labelText
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
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
            label.textColor = labelColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            var myText: String {
                if textfield.keyboardType == .numberPad {
                    return text.onlyDigits()
                }
                
                return text
            }
            
            textfield.text = myText
            
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
    }
    
    public override func showError(_ message: String, focusOnField: Bool = false) {
        lblError.text = message
        
        if focusOnField {
            textfield.becomeFirstResponder()
        }
        
        mainContainerView.jbBorderColor = errorColor
        icon.tintColor = errorColor
        label.textColor = errorColor
    }
    
    public override func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
        icon.tintColor = textfield.isFirstResponder ? highlightColor : .labelColor
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    override func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            icon.tintColor = textfield.isFirstResponder ? highlightColor : labelColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
            secondaryLabel.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            mainContainerView.jbBorderColor = errorColor
            icon.tintColor = errorColor
            label.textColor = errorColor
            secondaryLabel.textColor = errorColor
        }
        
        lblError.textColor = errorColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
        
//        textfield.addDoneButtonOnKeyboard(color: highlightColor)
    }
}

// Mark: UITextFieldDelegate
extension JBTextfield: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        label.textColor = isErrorTextEmpty ? highlightColor : errorColor
        secondaryLabel.textColor = isErrorTextEmpty ? highlightColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? highlightColor : errorColor
        icon.tintColor = isErrorTextEmpty ? highlightColor : errorColor
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
        secondaryLabel.textColor = isErrorTextEmpty ? labelColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? strokeColor : errorColor
        icon.tintColor = isErrorTextEmpty ? labelColor : errorColor
        
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
        
        var myFullText: String {
            if textfield.keyboardType == .numberPad {
                return fullText.onlyDigits()
            }
            
            return fullText
        }
        
        if textfield.keyboardType == .numberPad && !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}

@IBDesignable
public class JBPlainTextfield: BaseTextfield {
    public var minWidth: CGFloat = 100 {
        didSet {
            textfieldMinWidthConstraint.constant = minWidth
        }
    }
    
    public var textAlignment: NSTextAlignment = .right {
        didSet {
            textfield.textAlignment = textAlignment
        }
    }
    
    private var textfieldMinWidthConstraint: NSLayoutConstraint!
    
    override func setupView() {
        super.setupView()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = keyboardType
        textfield.textAlignment = textAlignment
        
        self.addSubview(textfield)
        
        textfield.pinToView(parentView: self)
        textfieldMinWidthConstraint = textfield.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfieldMinWidthConstraint
        ])
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
    }
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
        } else {
            var myText: String {
                if textfield.keyboardType == .numberPad {
                    return text.onlyDigits()
                }
                
                return text
            }
            
            textfield.text = myText
        }
    }
    
    override func setupColors() {
        
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
        
//        textfield.addDoneButtonOnKeyboard(color: highlightColor)
    }
}

// Mark: UITextFieldDelegate
extension JBPlainTextfield: UITextFieldDelegate {
    
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
        
        var myFullText: String {
            if textfield.keyboardType == .numberPad {
                return fullText.onlyDigits()
            }
            
            return fullText
        }
        
        if textfield.keyboardType == .numberPad && !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}

@IBDesignable
public class JBAmountTextfield: BaseTextfield {
    @IBInspectable public var currency = "KES" {
        didSet {
            secondaryLabel.text = currency
        }
    }
    
    override func setupView() {
        super.setupView()
        
        secondaryLabel.text = currency
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .decimalPad
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(secondaryLabel)
        containerView.addSubview(textfield)
        containerView.addSubview(label)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            labelHeightConstraint,
            labelLeadingConstraint
        ])
        
        icon.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        secondaryLabelLeadingConstraint = secondaryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        secondaryLabelLeadingConstraint?.isActive = true
        NSLayoutConstraint.activate([
            secondaryLabel.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
        ])
        
        textfield.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfield.topAnchor.constraint(equalTo: label.centerYAnchor),
            textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 10)
        label.leftInset = 50
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
        label.text = placeholder
    }
    
    public override func setPlaceholder(_ placeholder: String, labelText: String) {
        super.setPlaceholder(placeholder, labelText: labelText)
        textfield.placeholder = placeholder
        label.text = labelText
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
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
            label.textColor = labelColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            textfield.text = numberFormat(text.doubleValue(), maximumFractionDigits: 10)
            
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
    }
    
    public override func showError(_ message: String, focusOnField: Bool = false) {
        lblError.text = message
        
        if focusOnField {
            textfield.becomeFirstResponder()
        }
        
        mainContainerView.jbBorderColor = errorColor
        icon.tintColor = errorColor
        label.textColor = errorColor
        secondaryLabel.textColor = errorColor
    }
    
    public override func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
        icon.tintColor = textfield.isFirstResponder ? highlightColor : .labelColor
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        secondaryLabel.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    override func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            icon.tintColor = textfield.isFirstResponder ? highlightColor : labelColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            mainContainerView.jbBorderColor = errorColor
            icon.tintColor = errorColor
            label.textColor = errorColor
        }
        
        label.textColor = labelColor
        lblError.textColor = errorColor
        secondaryLabel.textColor = labelColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public override func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
                
        var myText = text.isEmpty ? text : numberFormat(text.doubleValue())
                
        let decimalSeparator = getDecimalSeparator()
        if text.hasSuffix(decimalSeparator) {
            myText += decimalSeparator
        } else if let decimalIndex = text.firstIndex(of: Character(decimalSeparator)) {
            let fractionPart = text[text.index(after: decimalIndex)...]
            myText += "\(decimalSeparator)\(fractionPart)"
        }
        
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBAmountTextfield: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        label.textColor = isErrorTextEmpty ? highlightColor : errorColor
        secondaryLabel.textColor = isErrorTextEmpty ? highlightColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? highlightColor : errorColor
        icon.tintColor = isErrorTextEmpty ? highlightColor : errorColor
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
        secondaryLabel.textColor = isErrorTextEmpty ? labelColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? strokeColor : errorColor
        icon.tintColor = isErrorTextEmpty ? labelColor : errorColor
        
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
        
        let myFullText = fullText.onlyNumeric()
                
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}

@IBDesignable
public class JBPlainAmountTextfield: BaseTextfield {
    @IBInspectable public var currency = "KES" {
        didSet {
            secondaryLabel.text = currency
        }
    }
    
    public var minWidth: CGFloat = 100 {
        didSet {
            textfieldMinWidthConstraint.constant = minWidth
        }
    }
    
    public var textAlignment: NSTextAlignment = .right {
        didSet {
            textfield.textAlignment = textAlignment
        }
    }
    
    private var textfieldMinWidthConstraint: NSLayoutConstraint!
    
    override func setupView() {
        super.setupView()
        
        secondaryLabel.text = currency
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .decimalPad
        textfield.textAlignment = textAlignment
        secondaryLabel.textAlignment = .right
        
        self.addSubview(secondaryLabel)
        self.addSubview(textfield)
        
        NSLayoutConstraint.activate([
            secondaryLabel.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        textfield.pinToView(parentView: self, leading: false)
        textfieldMinWidthConstraint = textfield.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfieldMinWidthConstraint,
            textfield.leadingAnchor.constraint(equalTo: secondaryLabel.trailingAnchor, constant: 5)
        ])
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
    }
    
    public override func setPlaceholder(_ placeholder: String, labelText: String) {
        super.setPlaceholder(placeholder, labelText: labelText)
        textfield.placeholder = placeholder
    }
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
        } else {
            textfield.text = numberFormat(text.doubleValue(), maximumFractionDigits: 10)
        }
    }
    
    override func setupColors() {
        secondaryLabel.textColor = labelColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public override func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
                
        var myText = text.isEmpty ? text : numberFormat(text.doubleValue())
                
        let decimalSeparator = getDecimalSeparator()
        if text.hasSuffix(decimalSeparator) {
            myText += decimalSeparator
        } else if let decimalIndex = text.firstIndex(of: Character(decimalSeparator)) {
            let fractionPart = text[text.index(after: decimalIndex)...]
            myText += "\(decimalSeparator)\(fractionPart)"
        }
        
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBPlainAmountTextfield: UITextFieldDelegate {
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
        
        let myFullText = fullText.onlyNumeric()
                
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}

@IBDesignable
public class JBNumberTextfield: BaseTextfield {
    override func setupView() {
        super.setupView()
                
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .decimalPad
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(textfield)
        containerView.addSubview(label)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            labelHeightConstraint,
            labelLeadingConstraint
        ])
        
        icon.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        textfield.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfield.topAnchor.constraint(equalTo: label.centerYAnchor),
            textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        label.leftInset = 0
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
        label.text = placeholder
    }
    
    public override func setPlaceholder(_ placeholder: String, labelText: String) {
        super.setPlaceholder(placeholder, labelText: labelText)
        textfield.placeholder = placeholder
        label.text = labelText
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
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
            label.textColor = labelColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            textfield.text = numberFormat(text.doubleValue(), maximumFractionDigits: 10)
            
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
    }
    
    public override func showError(_ message: String, focusOnField: Bool = false) {
        lblError.text = message
        
        if focusOnField {
            textfield.becomeFirstResponder()
        }
        
        mainContainerView.jbBorderColor = errorColor
        icon.tintColor = errorColor
        label.textColor = errorColor
        secondaryLabel.textColor = errorColor
    }
    
    public override func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
        icon.tintColor = textfield.isFirstResponder ? highlightColor : .labelColor
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        secondaryLabel.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    override func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            icon.tintColor = textfield.isFirstResponder ? highlightColor : labelColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            mainContainerView.jbBorderColor = errorColor
            icon.tintColor = errorColor
            label.textColor = errorColor
        }
        
        label.textColor = labelColor
        lblError.textColor = errorColor
        secondaryLabel.textColor = labelColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public override func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
                
        var myText = text.isEmpty ? text : numberFormat(text.doubleValue())
                
        let decimalSeparator = getDecimalSeparator()
        if text.hasSuffix(decimalSeparator) {
            myText += decimalSeparator
        } else if let decimalIndex = text.firstIndex(of: Character(decimalSeparator)) {
            let fractionPart = text[text.index(after: decimalIndex)...]
            myText += "\(decimalSeparator)\(fractionPart)"
        }
        
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBNumberTextfield: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        label.textColor = isErrorTextEmpty ? highlightColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? highlightColor : errorColor
        icon.tintColor = isErrorTextEmpty ? highlightColor : errorColor
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
        icon.tintColor = isErrorTextEmpty ? labelColor : errorColor
        
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
        
        let myFullText = fullText.onlyNumeric()
                
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}

@IBDesignable
public class JBPlainNumberTextfield: BaseTextfield {
    
    public var minWidth: CGFloat = 100 {
        didSet {
            textfieldMinWidthConstraint.constant = minWidth
        }
    }
    
    public var textAlignment: NSTextAlignment = .right {
        didSet {
            textfield.textAlignment = textAlignment
        }
    }
    
    private var textfieldMinWidthConstraint: NSLayoutConstraint!
    
    override func setupView() {
        super.setupView()
                
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .decimalPad
        textfield.textAlignment = textAlignment
        
        self.addSubview(textfield)
        
        textfield.pinToView(parentView: self)
        textfieldMinWidthConstraint = textfield.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfieldMinWidthConstraint
        ])
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
    }
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
        } else {
            textfield.text = numberFormat(text.doubleValue(), maximumFractionDigits: 10)
        }
    }
    
    override func setupColors() {
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public override func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
                
        var myText = text.isEmpty ? text : numberFormat(text.doubleValue())
                
        let decimalSeparator = getDecimalSeparator()
        if text.hasSuffix(decimalSeparator) {
            myText += decimalSeparator
        } else if let decimalIndex = text.firstIndex(of: Character(decimalSeparator)) {
            let fractionPart = text[text.index(after: decimalIndex)...]
            myText += "\(decimalSeparator)\(fractionPart)"
        }
        
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBPlainNumberTextfield: UITextFieldDelegate {
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
        
        let myFullText = fullText.onlyNumeric()
                
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}
