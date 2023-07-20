//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import UIKit

class CountryCell: UITableViewCell {
    private var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var checkIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "success", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .highlightColor
        return imgView
    }()
    
    var flagImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var lblName: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17)
        lbl.textColor = .labelColor
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var lblCode: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17)
        lbl.textColor = .labelColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var checkIconWidthConstraint: NSLayoutConstraint!
    private var lblCodeTrailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.addSubview(container)
        container.addSubview(checkIcon)
        container.addSubview(flagImg)
        container.addSubview(lblName)
        container.addSubview(lblCode)
        
        container.pinToView(parentView: self, constant: 0)
        
        NSLayoutConstraint.activate([
            flagImg.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            flagImg.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            flagImg.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15),
            flagImg.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        flagImg.applyAspectRatio(aspectRation: 16/10)
        
        NSLayoutConstraint.activate([
            lblName.leadingAnchor.constraint(equalTo: flagImg.trailingAnchor, constant: 15),
            lblName.trailingAnchor.constraint(equalTo: lblCode.leadingAnchor, constant: -15),
            lblName.centerYAnchor.constraint(equalTo: flagImg.centerYAnchor)
        ])
        
        lblCodeTrailingConstraint = lblCode.trailingAnchor.constraint(equalTo: checkIcon.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            lblCodeTrailingConstraint,
            lblCode.centerYAnchor.constraint(equalTo: flagImg.centerYAnchor),
            lblCode.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        checkIconWidthConstraint = checkIcon.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            checkIcon.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            checkIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkIcon.heightAnchor.constraint(equalToConstant: 18),
            checkIconWidthConstraint
        ])
    }
    
    func showCheckMark() {
        lblCodeTrailingConstraint.constant = -15
        checkIconWidthConstraint.constant = 18
    }
    
    func hideCheckMark() {
        lblCodeTrailingConstraint.constant = 0
        checkIconWidthConstraint.constant = 0
    }
}
