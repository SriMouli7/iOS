//
//  UIColor Extension.swift
//  SpiningLayers
//
//  Created by Sri Mouli Puttege on 9/8/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import Foundation
import UIKit


// different types of errors that might arise while custome initializing UIColor
enum UIColorInputError : ErrorType {
    case MissingHashMarkAsPrefix,
    UnableToScanHexValue,
    MismatchedHexStringLength
}


extension UIColor {
    // init with the hex value
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // init with rgba string
    convenience init(rgba: String, defaultColor: UIColor = UIColor.clearColor()) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(CGColor: defaultColor.CGColor)
            return
        }
        self.init(CGColor: color.CGColor)
    }
    
    // init with rgba string
    convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.MissingHashMarkAsPrefix
        }
        
        guard let hexString: String = rgba.substringFromIndex(rgba.startIndex.advancedBy(1)),
            var   hexValue:  UInt32 = 0
            where NSScanner(string: hexString).scanHexInt(&hexValue) else {
                throw UIColorInputError.UnableToScanHexValue
        }
        
        guard hexString.characters.count  == 3
            || hexString.characters.count == 4
            || hexString.characters.count == 6
            || hexString.characters.count == 8 else {
                throw UIColorInputError.MismatchedHexStringLength
        }
        
        switch (hexString.characters.count) {
        case 6:
            self.init(hex6: hexValue)
        default:
            self.init(hex6: hexValue)
        }
    }
    // init with hex value as well as alpha
    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // get color with modifications to any one of Hue, Saturation, Brightness and Alpha with required factor.
    func set(hueSaturationOrBrightness hsb: HSBA, percentage: CGFloat) -> UIColor {
        var hueValue : CGFloat = 0.0, saturationValue : CGFloat = 0.0, brightnessValue : CGFloat = 0.0, alphaValue : CGFloat = 0.0
        self.getHue(&hueValue, saturation: &saturationValue, brightness: &brightnessValue, alpha: &alphaValue)
        
        switch hsb {
        case .Hue:
            print(hueValue)
            return UIColor(hue: hueValue * percentage, saturation: saturationValue, brightness: brightnessValue, alpha: alphaValue)
        case .Saturation:
            return UIColor(hue: hueValue, saturation: saturationValue * percentage, brightness: brightnessValue, alpha: alphaValue)
        case .Brightness:
            return UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue * percentage, alpha: alphaValue)
        case .Alpha:
            return UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, alpha: alphaValue * percentage)
        }
    }
    
}


// define a enum type to hold Hue Saturation Brightness and Alpha
enum HSBA {
    case Hue
    case Saturation
    case Brightness
    case Alpha
}