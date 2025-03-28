//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import Foundation

extension String {
    func isNumeric() -> Bool {
        Int(self.onlyNumeric()) != nil || Float(self.onlyNumeric()) != nil || Double(self.onlyNumeric()) != nil
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
    
    func containsIgnoringCase(_ string: String) -> Bool {
        if let _ = self.range(of: string, options: .caseInsensitive) {
            return true
        }
        
        return false
    }
    
    func equalsIgnoringCase(_ string: String) -> Bool {
        return self.caseInsensitiveCompare(string) == .orderedSame
    }
    
    func onlyNumeric() -> String {
        self.filter({ $0.isNumber || $0 == Character(getDecimalSeparator()) })
    }
    
    func matches(for regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let matches  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.compactMap { match in
            guard let range = Range(match.range, in: self) else { return nil }
            return String(self[range])
        }
    }
    
    func doubleValue() -> Double {
        return Double(onlyNumeric()) ?? 0
    }
}

extension StringProtocol {
    subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>) -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>) -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
    
}
