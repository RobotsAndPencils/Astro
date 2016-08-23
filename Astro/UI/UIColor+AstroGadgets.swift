//  Copyright © 2016 Robots and Pencils, Inc. All rights reserved.
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

/**
 Includes a UIColor extension for hex code (e.g. #FF0000) support. You can now create your project's color palette in another class extension that brings all those pesky colors into one place and with names that are easy to understand:
 */
extension UIColor {
    /**
       Create a color from a string of hexadecimal characters.

       - parameter hexString: A six or eight-character string of hexadecimal (0-9, A-F) characters, optionally preceded with a # character. Every two characters represents the 0-255 value of a RGBA color component. For example, #FF0000 represents the color red, and #FF000099 would be a translucent red.
       - parameter alpha:     The desired alpha of the created color, from 0.0 to 1.0. If `hexString` contains an alpha component it will be multiplied with this value. Default value is 1.0.

       - returns: A new color created from the parsed values.
     */
    public convenience init?(hexString: String, alpha: Double = 1.0) {
        var parsedRed: UInt32 = 255
        var parsedGreen: UInt32 = 255
        var parsedBlue: UInt32 = 255
        var parsedAlpha: UInt32 = 255
        
        let hexCharacterSet = NSCharacterSet(charactersInString: "0123456789abcdefABCDEF")
        let hexOnlyString = hexString.componentsSeparatedByCharactersInSet(hexCharacterSet.invertedSet).joinWithSeparator("")
        
        guard hexOnlyString.characters.count >= 6 else {
            // There is a bug in stable Xcode 7.3 (SR-704) where returning nil
            // here will crash with EXC_BAD_ACCESS. Current workaround is to
            // call self/super.init() before returning nil.
            // Source: https://bugs.swift.org/browse/SR-704
            self.init()
            return nil
        }
        
        let redCharacterRange = hexOnlyString.startIndex..<hexOnlyString.startIndex.advancedBy(2)
        NSScanner(string: hexOnlyString.substringWithRange(redCharacterRange)).scanHexInt(&parsedRed)
        let greenCharacterRange = hexOnlyString.startIndex.advancedBy(2)..<hexOnlyString.startIndex.advancedBy(4)
        NSScanner(string: hexOnlyString.substringWithRange(greenCharacterRange)).scanHexInt(&parsedGreen)
        let blueCharacterRange = hexOnlyString.startIndex.advancedBy(4)..<hexOnlyString.startIndex.advancedBy(6)
        NSScanner(string: hexOnlyString.substringWithRange(blueCharacterRange)).scanHexInt(&parsedBlue)
        
        if hexOnlyString.characters.count == 8 {
            let alphaCharacterRange = hexOnlyString.startIndex.advancedBy(6)..<hexOnlyString.startIndex.advancedBy(8)
            NSScanner(string: hexOnlyString.substringWithRange(alphaCharacterRange)).scanHexInt(&parsedAlpha)
        }
        
        self.init(red: CGFloat(parsedRed) / 255.0, green: CGFloat(parsedGreen) / 255.0, blue: CGFloat(parsedBlue) / 255.0, alpha: (CGFloat(alpha) * CGFloat(parsedAlpha)) / 255.0)
    }

    /**
       Creates a hexadecimal string representation of a color. For example, UIColor.redColor().hexRGB() will return the string "FF0000".

       - returns: The hex string representation.
     */
    public func hexRGB() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        assert(getRed(&r, green: &g, blue: &b, alpha: &a), "Unable to get RGB channels from UIColor")
        return NSString(format:"%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255)) as String
    }

    /**
       Creates a hexadecimal string representation of a color. For example, UIColor.redColor().hexRGBA() will return the string "FF0000FF".

       - returns: The hex string representation.
     */
    public func hexRGBA() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        assert(getRed(&r, green: &g, blue: &b, alpha: &a), "Unable to get RGBA channels from UIColor")
        return NSString(format: "%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255)) as String
    }
}
