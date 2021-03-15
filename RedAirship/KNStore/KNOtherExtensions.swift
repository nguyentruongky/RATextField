//
//  OtherExtensions.swift
//  Coinhako
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import UIKit

extension Optional {
    func or<T>(_ defaultValue: T) -> T {
        switch(self) {
        case .none:
            return defaultValue
        case .some(let value):
            return value as! T
        }
    }
}

extension UIBarButtonItem {
    func format(font: UIFont, textColor: UIColor) {
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor]
        setTitleTextAttributes(attributes, for: UIControl.State.normal)
    }
}

extension UILabel{
    func setLineSpacing(_ lineSpacing: CGFloat = 7.0, alignment: NSTextAlignment = NSTextAlignment.left) {
        guard let labelText = text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = alignment
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        attributedText = attributedString
    }
}

extension UILabel{
    @discardableResult
    func formatParagraph(alignment: NSTextAlignment = NSTextAlignment.left, spacing: CGFloat = 7) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = alignment
        
        let ats = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        attributedText = NSAttributedString(string: text!, attributes: ats)
        return ats
    }
    
    func setCharacterSpacing(_ space: CGFloat) {
        guard let text = text else { return }
        let att: NSMutableAttributedString
        if let currentAtt = attributedText {
            att = NSMutableAttributedString(attributedString: currentAtt)
        } else {
            att = NSMutableAttributedString(string: text)
        }
        att.addAttribute(.kern, value: space,
                         range: NSRange(location: 0, length: text.count - 1))
        attributedText = att
    }
    
    func formatText(boldStrings: [String] = [],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = .black,
                    lineSpacing: CGFloat = 7,
                    alignment: NSTextAlignment = .left) {
        attributedText = String.format(strings: boldStrings,
                                       boldFont: boldFont,
                                       boldColor: boldColor,
                                       inString: text!,
                                       font: font,
                                       color: textColor,
                                       lineSpacing: lineSpacing,
                                       alignment: alignment)
    }
    
    func strikeout() {
        guard let text = text else { return }
        let att = NSMutableAttributedString(string: text)
        att.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1,
                         range: NSMakeRange(0, att.length))
        attributedText = att
    }
    
    func underline(string: String) {
        let attributedString: NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: text ?? "")
        }
        guard let text = text, let index = text.indexOf(string) else { return }
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(index, string.count))
        attributedText = attributedString
    }
    
    func addCharacterSpacing(_ space: CGFloat) {
        guard let text = text else { return }
        let att = NSMutableAttributedString(string: text)
        att.addAttribute(NSAttributedString.Key.kern, value: 1.5,
                         range: NSMakeRange(0, att.length))
        attributedText = att
    }
}

extension UIScrollView {
    func animateView(animatedView: UIView, staticView: UIView) {
        var headerTransform = CATransform3DIdentity
        let yOffset = contentOffset.y
        staticView.isHidden = yOffset < 0
        animatedView.isHidden = yOffset > 0
        if yOffset < 0 {
            let headerScaleFactor:CGFloat = -(yOffset) / animatedView.bounds.height
            let headerSizevariation = ((animatedView.bounds.height * (1.0 + headerScaleFactor)) - animatedView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            animatedView.layer.transform = headerTransform
        }
    }
}

extension UICollectionView {
    func dequeue<T>(at indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
}

extension UITextView {
    func wrapText(aroundRect rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        textContainer.exclusionPaths = [path]
    }
}

extension Bundle {
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    func getJson(from file: String) -> AnyObject? {
        guard let filePath = path(forResource: file, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return jsonResult as AnyObject
        } catch { return nil }
    }
}


extension UITabBar {
    func removeLine() {
        shadowImage = UIImage()
        backgroundImage = UIImage()
    }
}

extension UITabBarController {
    func setTabBar(visible: Bool) {
        tabBar.frame.size.height = visible ? 49 : 0
        tabBar.isHidden = !visible
    }
}


extension UserDefaults {
    static func set<T>(key: String, value: T?) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func get<T>(key: String) -> T? {
        return UserDefaults.standard.value(forKeyPath: key) as? T
    }
}

