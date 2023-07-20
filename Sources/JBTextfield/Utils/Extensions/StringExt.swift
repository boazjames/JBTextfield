//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import Foundation

extension String {
    func isNumeric() -> Bool {
        Int(self) != nil || Float(self) != nil || Double(self) != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
}
