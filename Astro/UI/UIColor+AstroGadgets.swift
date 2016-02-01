//
//  UIView+AstroGadgets.swift
//  Astro
//
//  Created by Brandon Evans on 2016-01-29.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

extension UIColor {
    public convenience init?(hexString: String, alpha: Double = 1.0) {
        var parsedRed: UInt32 = 255
        var parsedGreen: UInt32 = 255
        var parsedBlue: UInt32 = 255
        var parsedAlpha: UInt32 = 255

        let hexCharacterSet = NSCharacterSet(charactersInString: "0123456789abcdefABCDEF")
        let hexOnlyString = hexString.componentsSeparatedByCharactersInSet(hexCharacterSet.invertedSet).joinWithSeparator("")

        guard hexOnlyString.characters.count >= 6 else {
            return nil
        }

        let redCharacterRange = Range(start: hexOnlyString.startIndex, end: hexOnlyString.startIndex.advancedBy(2))
        NSScanner(string: hexOnlyString.substringWithRange(redCharacterRange)).scanHexInt(&parsedRed)
        let greenCharacterRange = Range(start: hexOnlyString.startIndex.advancedBy(2), end: hexOnlyString.startIndex.advancedBy(4))
        NSScanner(string: hexOnlyString.substringWithRange(greenCharacterRange)).scanHexInt(&parsedGreen)
        let blueCharacterRange = Range(start: hexOnlyString.startIndex.advancedBy(4), end: hexOnlyString.startIndex.advancedBy(6))
        NSScanner(string: hexOnlyString.substringWithRange(blueCharacterRange)).scanHexInt(&parsedBlue)
        
        if hexOnlyString.characters.count == 8 {
            let alphaCharacterRange = Range(start: hexOnlyString.startIndex.advancedBy(6), end: hexOnlyString.startIndex.advancedBy(8))
            NSScanner(string: hexOnlyString.substringWithRange(alphaCharacterRange)).scanHexInt(&parsedAlpha)
        }

        self.init(red: CGFloat(parsedRed) / 255.0, green: CGFloat(parsedGreen) / 255.0, blue: CGFloat(parsedBlue) / 255.0, alpha: (CGFloat(alpha) * CGFloat(parsedAlpha)) / 255.0)
    }
    
    public func hexRGB() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        assert(getRed(&r, green: &g, blue: &b, alpha: &a), "Unable to get RGB channels from UIColor")
        return NSString(format:"%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255)) as String
    }
    
    public func hexRGBA() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        assert(getRed(&r, green: &g, blue: &b, alpha: &a), "Unable to get RGBA channels from UIColor")
        return NSString(format: "%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255)) as String
    }
}
