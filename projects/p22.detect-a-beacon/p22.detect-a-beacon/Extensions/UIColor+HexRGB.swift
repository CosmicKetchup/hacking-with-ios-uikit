//
//  UIColor+HexRGB.swift
//  p22.detect-a-beacon
//
//  Created by Matt Brown on 1/20/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

extension UIColor {

    static func rgb(_ red: UInt8, _ green: UInt8, _ blue: UInt8, alpha aV: CGFloat = 1.0) -> UIColor {
        let rV = CGFloat(red) / 255
        let gV = CGFloat(green) / 255
        let bV = CGFloat(blue) / 255
        
        return UIColor(red: rV, green: gV, blue: bV, alpha: aV)
    }
    
    // Paul Hudson - https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
    public convenience init?(hex input: String, alpha aV: CGFloat = 1.0) {
        guard let hexRegex = try? NSRegularExpression(pattern: "((([a-fA-F]|[0-9]){2}){3})", options: .caseInsensitive) else { fatalError("Invalid hex string!") }
        assert(hexRegex.numberOfMatches(in: input, range: NSRange(location: 0, length: input.utf16.count)) == 1,
               "Unable to create UIColor due to invalid hexadecimal value. Please refer to documentation.")
        
        let scanner = Scanner(string: input)
        var hexNum: UInt64 = 0
        guard scanner.scanHexInt64(&hexNum) else { return nil }
        
        let rV, gV, bV: CGFloat
        rV = CGFloat((hexNum & 0xff0000) >> 16) / 255
        gV = CGFloat((hexNum & 0x00ff00) >> 8) / 255
        bV = CGFloat((hexNum & 0x0000ff) >> 0) / 255
        
        self.init(red: rV, green: gV, blue: bV, alpha: aV)
    }
}
