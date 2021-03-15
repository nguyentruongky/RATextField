//
//  RAFonts.swift
//  RedAirship
//
//  Created by Ky Nguyen on 3/16/21.
//

import UIKit

extension UIFont {
    enum RAWeight: String {
        case bold = "OpenSans-Bold"
        case semiBold = "OpenSans-SemiBold"
        case regular = "OpenSans-Regular"
        case light = "OpenSans-Light"
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return font(weight: .regular, size: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return font(weight: .bold, size: size)
    }
    
    static func semiBold(size: CGFloat) -> UIFont {
        return font(weight: .semiBold, size: size)
    }
    
    static func light(size: CGFloat) -> UIFont {
        return font(weight: .light, size: size)
    }
    
    static func font(weight: RAWeight = .regular, size: CGFloat = 15) -> UIFont {
        return getFont(weight.rawValue, size: size)
    }
    
    static func big(weight: RAWeight = .regular) -> UIFont {
        return font(weight: weight, size: 40)
    }
    
    static func h1(weight: RAWeight = .bold) -> UIFont {
        return font(weight: weight, size: 26)
    }
    
    static func h2(weight: RAWeight = .bold) -> UIFont {
        return font(weight: weight, size: 20)
    }
    
    static func h3(weight: RAWeight = .semiBold) -> UIFont {
        return font(weight: weight, size: 18)
    }
    
    static func getFont(_ name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else { return UIFont.boldSystemFont(ofSize: size) }
        return font
    }
}
