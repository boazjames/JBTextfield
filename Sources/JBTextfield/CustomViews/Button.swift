//
//  Button.swift
//
//
//  Created by Boaz James on 21/06/2024.
//

import UIKit

class MyButton: UIButton {
    var title = "" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    var font = UIFont.systemFont(ofSize: 15) {
        didSet {
            if #available(iOS 15.0, *) {
                var config = self.configuration
                config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = self.font
                    return outgoing
                }
                
                self.configuration = config
            } else {
                self.titleLabel?.font = font
            }
        }
    }
    
    var inset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) {
        didSet {
            if #available(iOS 15.0, *) {
                var config = self.configuration
                config?.contentInsets = inset
                
                self.configuration = config
            } else {
                self.contentEdgeInsets = UIEdgeInsets(top: inset.top, left: inset.leading, bottom: inset.trailing, right: inset.trailing)
            }
        }
    }
    
    var customBackgroundColor: UIColor = .highlightColor {
        didSet {
            if #available(iOS 15.0, *) {
                var config = self.configuration
                var backgroundConfig = UIBackgroundConfiguration.clear()
                backgroundConfig.backgroundColor = customBackgroundColor
                config?.background = backgroundConfig
                
                self.configuration = config
            }
            
            backgroundColor = customBackgroundColor
        }
    }
    
    private var height: CGFloat = 46
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    init(height: CGFloat) {
        super.init(frame: .zero)
        self.height = height
        
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = customBackgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.darkGray, for: .highlighted)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).activate()
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePlacement = .leading
            config.imagePadding = 10
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = self.font
                return outgoing
            }
            
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = customBackgroundColor
            config.background = backgroundConfig
            
            self.configuration = config
        } else {
            self.titleLabel?.font = font
        }
    }
}
