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

func formatNumber(_ num: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return numberFormatter.string(from: NSNumber(value:num)) ?? "0"
}

func formatNumber(_ num: Float) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return numberFormatter.string(from: NSNumber(value:num)) ?? "0"
}

func formatNumber(_ num: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return numberFormatter.string(from: NSNumber(value:num)) ?? "0"
}


func cleanAmountText(text: String) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
    return text.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".00", with: "").replacingOccurrences(of: numberFormatter.groupingSeparator ?? "", with: "")
}

func cleanPAN(PAN: String) -> String {
    return PAN.replacingOccurrences(of: "-", with: "")
}
