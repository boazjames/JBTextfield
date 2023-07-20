import UIKit

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
            textfield.keyboardType = keyboardType
            setText(text)
        }
    }
    
    @IBInspectable public var textContentType: UITextContentType? {
        didSet {
            textfield.textContentType = textContentType
            setText(text)
        }
    }
    
    var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderWidth = 1
        view.viewCornerRadius = 5
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
        view.font = .systemFont(ofSize: 12)
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
        view.font = .systemFont(ofSize: 14)
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
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = 0
        view.leftInset = 0
        view.rightInset = 0
        view.topInset = 0
        view.bottomInset = 0
        return view
    }()
    
    var textfield: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .default
        textField.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return textField
    }()
    
    var icon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        view.applyAspectRatio(aspectRation: 1)
        return view
    }()
    
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
        
//        textfield.addDoneButtonOnKeyboard(color: highlightColor)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focusTextField)))
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
    }
    
    func setupColors() {}
}

@IBDesignable
public class JBTextfield: BaseTextfield {
    
    override func setupView() {
        super.setupView()
        
        mainContainerView.backgroundColor = .textFieldBackgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .alphabet
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(textfield)
        containerView.addSubview(label)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10),
            labelHeightConstraint
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
        
        mainContainerView.borderColor = errorColor
        icon.tintColor = errorColor
        label.textColor = errorColor
    }
    
    public override func hideError() {
        lblError.text = nil
        mainContainerView.borderColor = textfield.isFirstResponder ? highlightColor : .clear
        icon.tintColor = textfield.isFirstResponder ? highlightColor : .clear
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    override func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.borderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            icon.tintColor = textfield.isFirstResponder ? highlightColor : labelColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            mainContainerView.borderColor = errorColor
            icon.tintColor = errorColor
            label.textColor = errorColor
        }
        
        label.textColor = labelColor
        lblError.textColor = errorColor
        secondaryLabel.textColor = labelColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
        
//        textfield.addDoneButtonOnKeyboard(color: highlightColor)
    }
}

// Mark: UITextFieldDelegate
extension JBTextfield: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        label.textColor = highlightColor
        mainContainerView.borderColor = highlightColor
        icon.tintColor = highlightColor
        if let text = textField.text {
            if text.isEmpty {
                showLabel()
            }
        } else {
            showLabel()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        label.textColor = labelColor
        mainContainerView.borderColor = strokeColor
        icon.tintColor = labelColor
        
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
