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
