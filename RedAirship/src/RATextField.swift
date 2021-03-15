//
//  RATextField.swift
//  RedAirship
//
//  Created by Ky Nguyen on 3/15/21.
//

import UIKit

class RATextField: UITextField {
    struct FormatOption {
        var titleColor = UIColor.black
        var titleFont = UIFont.systemFont(ofSize: 12)
        var titleY: CGFloat = -12
        
        var lineActiveColor = UIColor.blue
        var lineInactiveColor = UIColor.lightGray
        var errorColor = UIColor.red
        var helperColor = UIColor.darkGray
        var leftPadding: CGFloat = 8
    }
    

    private var titleLabel = UILabel()
    private let helperLabel = UILabel(font: .systemFont(ofSize: 12),
                                      color: .red)
    private var option: FormatOption
    private let underline = UIView(background: .gray)
    private var hasError = false
    
    private var isStatic = false 
    
    // Initialize
    
    override init(frame: CGRect) {
        option = FormatOption()
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(label: String, option: FormatOption = FormatOption()) {
        self.init(frame: .zero)
        self.option = option
        titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.textColor = .black
        setupPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        option = FormatOption()
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        underline.backgroundColor = option.lineInactiveColor
        addSubviews(views: underline)
        underline.horizontalSuperview()
        underline.bottomToSuperview()
        underline.height(1)
        
        helperLabel.isHidden = true
        addSubviews(views: helperLabel)
        helperLabel.horizontalSuperview(space: 8)
        helperLabel.bottomToSuperview(space: 16)
    }
    
    
    
    // Override fields/functions
    
    override var font: UIFont? {
        didSet {
            if let font = font {
                option.titleFont = font.withSize(font.pointSize - 4)
            }
            titleLabel.font = font
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var frame = bounds
        frame.origin.x = option.leftPadding
        return frame
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var frame = bounds
        frame.origin.x = option.leftPadding
        return frame
    }
        
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        movePlaceholderUp()
        setUnderlineStatus(hasError ? .error : .active)
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if text?.isEmpty == true {
            movePlaceholderDown()
        }
        setUnderlineStatus(hasError ? .error : .inactive)
        return result
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if text?.isEmpty == true, isFirstResponder == false {
            movePlaceholderDown()
        } else  {
            setTitleY(option.titleY)
        }
    }

    
    
    // Placeholder functions
    
    private func setupPlaceholder() {
        let defaultFont = font ?? UIFont.systemFont(ofSize: 17)
        option.titleFont = defaultFont
        titleLabel.font = font
        addSubviews(views: titleLabel)
        titleLabel.leftToSuperview(space: option.leftPadding)
        titleLabel.centerYToSuperview()
    }

    private func movePlaceholderUp() {
        titleLabel.font = option.titleFont.withSize(option.titleFont.pointSize - 4)
        layoutIfNeeded()
        let y = option.titleY
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            self?.setTitleY(y)
        }
    }
    
    private func movePlaceholderDown() {
        titleLabel.font = option.titleFont
        let textFieldHeight = frame.height
        let y = (textFieldHeight - titleLabel.frame.height) / 2
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            self?.setTitleY(y)
        }
    }
    
    
    
    // Helper text
    
    func setHelper(visible: Bool, content: String? = nil) {
        if (isStatic) {
            return
        }
        hasError = false
        setUnderlineStatus(isFirstResponder ? .active : .inactive)

        if visible {
            helperLabel.isHidden = false
            
            helperLabel.isHidden = false
            helperLabel.text = content
            helperLabel.textColor = option.helperColor
        } else {
            helperLabel.isHidden = true
        }
    }
    
    func setError(visible: Bool, content: String? = nil) {
        if (isStatic) {
            return
        }
        hasError = visible
        if visible {
            helperLabel.isHidden = false
            
            helperLabel.isHidden = false
            helperLabel.text = content
            helperLabel.textColor = option.errorColor
            setUnderlineStatus(.error)
        } else {
            helperLabel.isHidden = true
            setUnderlineStatus(isFirstResponder ? .active : .inactive)
        }
    }
    
    func setStatic(isEnabled: Bool, helper: String? = nil) {
        if isEnabled {
            self.isEnabled = false
            setHelper(visible: true, content: helper)
            setUnderlineStatus(.hidden)
            setStaticFont(isStatic: true)
        } else {
            self.isEnabled = true
            setUnderlineStatus(isFirstResponder ? .active : .inactive)
            setStaticFont(isStatic: false)
        }
        isStatic = isEnabled
    }
}

extension RATextField {
    enum UnderlineStatus {
        case active, inactive
        case error
        case hidden
    }
}

extension RATextField {
    
    private func setUnderlineStatus(_ status: UnderlineStatus) {
        underline.isHidden = false
        switch status {
            case .active:
                underline.backgroundColor = option.lineActiveColor
            case .inactive:
                underline.backgroundColor = option.lineInactiveColor
            case .error:
                underline.backgroundColor = option.errorColor
            case .hidden:
                underline.isHidden = true
        }
    }
    
    private func setTitleY(_ value: CGFloat) {
        let newRect = CGRect(x: option.leftPadding,
                             y: value,
                             width: titleLabel.frame.width,
                             height: titleLabel.frame.height)
        titleLabel.frame = newRect
    }
    
    private func setStaticFont(isStatic: Bool) {
        let titleFont = option.titleFont
        if isStatic {
            font = font?.withWeight(.bold)
        } else {
            font = titleFont
        }
        
        option.titleFont = titleFont
        titleLabel.font = titleFont.withSize(titleFont.pointSize - 4)
    }
}

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [
                                                                UIFontDescriptor.TraitKey.weight: weight]
        ])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}
