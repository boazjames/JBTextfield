//
//  File.swift
//  
//
//  Created by Boaz James on 09/05/2024.
//

import UIKit

public class TextView: UIView {
    @IBInspectable public var maxLength = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {}
    
    public func setPlaceholder(_ placeholder: String) {}
    
    public func setText(_ text: String) {}
}


public class JBTextView: TextView {
    
    public var isEmpty = true
    
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
    
    @IBInspectable public var keyboardType: UIKeyboardType = UIKeyboardType.default {
        didSet {
            textfield.keyboardType = keyboardType
            setText(text)
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
    
    public private(set) var placeholder = ""
    public private(set) var text = ""
    
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
    
    private(set) var label: PaddingLabel = {
        let view = PaddingLabel()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .labelColor
        view.textAlignment = .left
        view.numberOfLines = 0
        view.leftInset = 5
        view.rightInset = 5
        view.topInset = 0
        view.bottomInset = 0
        view.labelCornerRadius = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    
    public private(set) var textfield: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContentType = .none
        textView.isScrollEnabled = true
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.backgroundColor = .clear
        textView.textColor = .placeholderColor
        textView.contentInset = .zero
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
        return textView
    }()
    
    let lblError: PaddingLabel = {
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
    
    private var labelHeightConstraint: NSLayoutConstraint!
    
    override func setupView() {
        mainContainerView.backgroundColor = boxBackgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = keyboardType
        
        label.font = labelFont
        textfield.font = textfieldFont
        lblError.font = errorLabelFont
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(textfield)
        containerView.addSubview(label)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        
        containerView.pinToView(parentView: mainContainerView)
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -5),
            labelHeightConstraint
        ])
        
        textfield.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 105),
            textfield.topAnchor.constraint(equalTo: label.centerYAnchor),
            textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        setupColors()
        
        textfield.delegate = self
    }
    
    private func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            mainContainerView.jbBorderColor = errorColor
            label.textColor = errorColor
        }
        
        lblError.textColor = errorColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public func showError(_ message: String, focusOnField: Bool = false) {
        lblError.text = message
        
        if focusOnField {
            textfield.becomeFirstResponder()
        }
        
        mainContainerView.jbBorderColor = errorColor
        label.textColor = errorColor
    }
    
    public func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
        if isEmpty && !textfield.isFirstResponder {
            self.textfield.text = placeholder
            self.textfield.textColor = .placeholderColor
        }
        label.text = placeholder
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
        self.isEmpty = text.isEmpty
        self.text = text
        if text.isEmpty {
//            textfield.text = text
            label.textColor = .secondaryLabelColor
            
            textfield.text = placeholder
            textfield.textColor = .placeholderColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            textfield.text = text
            label.textColor = .labelColor
            
            textfield.textColor = .labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
    }
}

// Mark: UITextViewDelegate
extension JBTextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        label.textColor = isErrorTextEmpty ? highlightColor : errorColor
        mainContainerView.jbBorderColor =  isErrorTextEmpty ? highlightColor : errorColor
        
        if self.isEmpty {
            showLabel()
            textView.text = nil
        }
        
        textView.textColor = .labelColor
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        label.textColor =  isErrorTextEmpty ? labelColor : errorColor
        mainContainerView.jbBorderColor =  isErrorTextEmpty ? strokeColor : errorColor
        
        if self.isEmpty {
            hideLabel()
            textView.text = placeholder
            textView.textColor = .placeholderColor
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        var fullText: String {
            if text.isEmpty {
                var text = currentText
                guard let myRange = Range(range, in: currentText) else { return text}
                text.replaceSubrange(myRange, with: text)
                
                return text
            }
            
            return "\(currentText)\(text)"
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
                                
        return myFullText.count <= maxLength || maxLength == 0
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
        if let text = textView.text {
            self.isEmpty = text.isEmpty
        } else {
            self.isEmpty = true
        }
        
        hideError()
    }
}
