//
//  JBCountryPickerView.swift
//  JBTextfield
//
//  Created by Boaz James on 21/05/2025.
//

import UIKit

@IBDesignable
public class JBCountryPickerView: BasePickerView {
    
    let flagImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "ke", in: .module, compatibleWith: nil)
        return imgView
    }()
    
    public var customDialCodes = [String]()
    public var selectedCountry = JBCountry(name: "Kenya", code: "KE", dialCode: "254")
    var selectedCountryCode = "254"
    public var actionButtonClosure:  ((_ country: JBCountry, _ flag: UIImage?) -> Void)?
    
    override func setupViews() {
        super.setupViews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(placeHolderLabel)
        containerView.addSubview(label)
        containerView.addSubview(flagImg)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 0),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        placeHolderLabelLeadingConstraint = placeHolderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50)
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            placeHolderLabelLeadingConstraint,
            placeHolderLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10)
        ])
        
        flagImg.applyAspectRatio(aspectRation: 3 / 2)
        NSLayoutConstraint.activate([
            flagImg.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            flagImg.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            flagImg.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        labelHeightConstraint = placeHolderLabel.heightAnchor.constraint(equalToConstant: 0)
        labelTopConstraint = label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        label.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            labelTopConstraint,
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            labelHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        label.leftInset = 50
        
        mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryPicker)))
        
        setPlaceholder("Country".localized)
        setCountry(selectedCountry)
    }
    
    override public func setPlaceholder(_ placeholder: String) {
        self.labelText = placeholder
        placeHolderLabel.text = placeholder
//        label.text = placeholder
    }
    
    override public func setText(_ text: String, value: String) {
        self.value = value
        self.text = text
        if text.isEmpty {
            label.text = self.labelText
            label.textColor = placeholderColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            label.text = text
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
        
        hideError()
    }
    
    private func showLabel() {
        labelTopConstraint.constant = 25
        self.layoutIfNeeded()
        let originY = label.frame.origin.y
        let distance: CGFloat = 20
        placeHolderLabel.frame.origin.y = originY + distance
        self.bringSubviewToFront(placeHolderLabel)
        
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.deactivate()
            self.placeHolderLabel.frame.origin.y = originY
            self.layoutIfNeeded()
        }
    }
    
    private func hideLabel() {
        labelTopConstraint.constant = 15
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.activate()
            self.layoutIfNeeded()
        }
    }
    
    public func setCountry(_ country: JBCountry) {
        selectedCountry = country
        selectedCountryCode = country.dialCode
        flagImg.image = UIImage(named: country.code.lowercased(), in: .module, compatibleWith: nil)
        setText(country.name, value: "")
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
            setText(country.name, value: "")
        }
    }
    
    @objc func showCountryPicker() {
        let vc = CountryPickerVC()
        vc.selectedCountryCode = selectedCountryCode
        vc.customDialCodes = customDialCodes
        vc.completion = { country, image in
            self.setCountry(country)
            self.flagImg.image = image
        }
        let nc = UINavigationController(rootViewController: vc)
        findViewController()?.present(nc, animated: true)
    }
}
