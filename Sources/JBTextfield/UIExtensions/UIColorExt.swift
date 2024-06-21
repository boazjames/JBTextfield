//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import UIKit

extension UIColor {
    static var labelColor: UIColor {
        if let color = UIColor(named: "ColorLabel", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorLabel", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var secondaryLabelColor: UIColor {
        if let color = UIColor(named: "ColorSecondaryLabel", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorSecondaryLabel", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var textFieldBackgroundColor: UIColor {
        if let color = UIColor(named: "ColorTextFieldBackground", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorTextFieldBackground", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var placeholderColor: UIColor {
        if let color = UIColor(named: "ColorPlaceholder", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorPlaceholder", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var highlightColor: UIColor {
        if let color = UIColor(named: "ColorHighlight", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorHighlight", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var errorColor: UIColor {
        if let color = UIColor(named: "ColorError", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorError", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var strokeColor: UIColor {
        if let color = UIColor(named: "ColorStroke", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorStroke", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var backgroundColor: UIColor {
        if let color = UIColor(named: "ColorBackground", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorBackground", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var skyBlueLightColor: UIColor {
        if let color = UIColor(named: "ColorSkyBlueLight", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorSkyBlueLight", in: Bundle.module, compatibleWith: nil)!
    }
    
    static var whiteColor: UIColor {
        if let color = UIColor(named: "ColorWhite", in: Bundle.main, compatibleWith: nil) {
            return color
        }
        
        return UIColor(named: "ColorWhite", in: Bundle.module, compatibleWith: nil)!
    }
}
