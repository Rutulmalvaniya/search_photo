//
//  Constant.swift
//  Kavita Project 2
//
//  Created by apple  on 14/08/22.
//

import Foundation
import UIKit

struct K {
    struct AppColor {
        static var background = hexStringToUIColor(hex: "#e7e7ff")
        static var appBlack = hexStringToUIColor(hex: "#292c31")
        static var buttonBackground = hexStringToUIColor(hex: "#41dccb")
        static var textFieldBackground = hexStringToUIColor(hex: "#f8f9fe")
        static var navigationBarColor = hexStringToUIColor(hex: "#c9f1fc")
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
