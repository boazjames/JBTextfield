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
    
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .module, comment: "")
    }
    
    func grouping(every groupSize: Int, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
        }.joined().dropFirst())
    }
    
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
