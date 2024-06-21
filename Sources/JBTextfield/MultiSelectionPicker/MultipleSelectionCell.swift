//
//  MultipleSelectionCell.swift
//
//
//  Created by Boaz James on 21/06/2024.
//

import UIKit

class MultipleSelectionCell: UITableViewCell {
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let imgCheck: UIImageView =  {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .highlightColor
        return view
    }()
    
    private let lblTitle: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .labelColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.contentView.addSubview(container)
        container.addSubview(lblTitle)
        container.addSubview(imgCheck)
        
        container.pinToView(parentView: self.contentView)
        
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: imgCheck.trailingAnchor, constant: -10),
            lblTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            lblTitle.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
        ])
        
        imgCheck.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            imgCheck.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imgCheck.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imgCheck.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    func configure(_ item: JBPickerItem) {
        lblTitle.text = item.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            imgCheck.image = UIImage(named: "success")?.withRenderingMode(.alwaysTemplate)
        } else {
            imgCheck.image = nil
        }
    }
}
