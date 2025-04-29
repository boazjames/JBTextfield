//
//  File.swift
//  
//
//  Created by Boaz James on 21/07/2023.
//

import UIKit

func safeAreaBottomInset() -> CGFloat  {
    return UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0
}

func safeAreaTopInset() -> CGFloat  {
    return UIWindow.keyWindow?.safeAreaInsets.top ?? 0
}

func numberFormat(_ value: Float, maximumFractionDigits: Int = 0) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    numberFormatter.maximumFractionDigits = maximumFractionDigits
    numberFormatter.roundingMode = .down
    return numberFormatter.string(from: NSNumber(value:value)) ?? ""
}

func numberFormat(_ value: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return numberFormatter.string(from: NSNumber(value:value)) ?? ""
}

func numberFormat(_ value: Double, maximumFractionDigits: Int = 0) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    numberFormatter.maximumFractionDigits = maximumFractionDigits
    numberFormatter.roundingMode = .down
    return numberFormatter.string(from: NSNumber(value:value)) ?? ""
}


func cleanAmountText(text: String) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return text.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: numberFormatter.groupingSeparator ?? "", with: "")
}

func cleanPAN(PAN: String) -> String {
    return PAN.replacingOccurrences(of: "-", with: "")
}


func getDecimalSeparator() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return numberFormatter.decimalSeparator ?? ""
}


func getNumberSeparator() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return numberFormatter.groupingSeparator ?? ""
}

func cleanCreditCardExpiryDate(text: String) -> String {
    return text.replacingOccurrences(of: "/", with: "")
}
