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
        
        var leftPadding: CGFloat = 32
        var prefixColor = UIColor.black
        
        var rightPadding: CGFloat = 32
        var suffixColor = UIColor.black
        
        var iconSize: CGFloat = 32
        var iconColor = UIColor.black
    }
    

    weak var raDelegate: RATextFieldDelegate?
    
    private let titleLabel = UILabel()
    private let helperLabel = UILabel(font: .systemFont(ofSize: 12), color: .red)
    private var prefixLabel: UILabel?
    private var suffixLabel: UILabel?
    private var leftIcon: UIImageView?
    private var rightIcon: UIImageView?
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
        titleLabel.text = label
        titleLabel.textColor = .black
        setupPlaceholder()
    }
    
    convenience init(prefix: String, option: FormatOption = FormatOption()) {
        self.init(frame: .zero)
        self.option = option
        setupPrefix(prefix)
    }
    
    convenience init(suffix: String, option: FormatOption = FormatOption()) {
        self.init(frame: .zero)
        self.option = option
        setupSuffix(suffix)
    }
    
    convenience init(leftIcon: UIImage, option: FormatOption = FormatOption()) {
        self.init(frame: .zero)
        self.option = option
        setupLeftIcon(leftIcon)
    }
    
    convenience init(rightIcon: UIImage, option: FormatOption = FormatOption()) {
        self.init(frame: .zero)
        self.option = option
        setupRightIcon(rightIcon)
    }
    
    required init?(coder: NSCoder) {
        option = FormatOption()
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        textColor = UIColor.black
        
        underline.backgroundColor = option.lineInactiveColor
        addSubviews(views: underline)
        underline.horizontalSuperview()
        underline.bottomToSuperview()
        underline.height(1)
        
        helperLabel.isHidden = true
        addSubviews(views: helperLabel)
        helperLabel.horizontalSuperview()
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
        return getTextArea(bounds: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return getTextArea(bounds: bounds)
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
        
        layoutTitle()
        if text?.isEmpty == true, isFirstResponder == false {
            movePlaceholderDown()
        } else  {
            setTitleY(option.titleY)
        }
        
        layoutIconIfNeeded(leftIcon)
        layoutIconIfNeeded(rightIcon)
        
    }

    
    
    
    
}



// MARK: TITLE PLACEHOLDER
extension RATextField {
    private func layoutTitle() {
        if let icon = leftIcon {
            titleLabel.frame.origin.x = icon.frame.width + option.leftPadding
        }
        
        titleLabel.frame.origin.y = (frame.height - titleLabel.frame.height) / 2
    }
    
    // Placeholder functions
    
    func setTitle(_ title: String) {
        setupPlaceholder()
        titleLabel.text = title
    }
    
    private func setupPlaceholder() {
        let defaultFont = font ?? UIFont.systemFont(ofSize: 17)
        option.titleFont = defaultFont
        titleLabel.font = font
        titleLabel.textColor = option.titleColor
        addSubviews(views: titleLabel)
//        titleLabel.leftToSuperview()
//        titleLabel.centerYToSuperview()
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
    
}



// MARK: HELPER TEXT
extension RATextField {
    
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



// MARK: PREFIX SUFFIX

extension RATextField {
    
    // Prefix
    
    private func setupPrefix(_ text: String) {
        let label = UILabel(text: text, color: option.prefixColor)
        label.sizeToFit()
        label.frame.size.width += 32
        leftView = label
        leftViewMode = .always
        
        addGesture(to: label, selector: #selector(didPressPrefix))
        prefixLabel = label
    }
    
    @objc private func didPressPrefix(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        raDelegate?.didPressPrefix?(label: label)
    }
    
    
    
    // Suffix
    
    private func setupSuffix(_ text: String) {
        let label = UILabel(text: text, color: option.prefixColor, alignment: .center)
        label.sizeToFit()
        label.frame.size.width += 32
        rightView = label
        rightViewMode = .always
        
        addGesture(to: label, selector: #selector(didPressSuffix))
        suffixLabel = label
    }
    
    @objc private func didPressSuffix(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        raDelegate?.didPressSuffix?(label: label)
    }
    
}



// MARK: LEFT RIGHT ICON
extension RATextField {
    private func layoutIconIfNeeded(_ icon: UIImageView?) {
        if let icon = icon {
            icon.frame.origin.y = (frame.height - icon.frame.height) / 2
        }
    }
    
    // Left Icon
    
    private func setupLeftIcon(_ icon: UIImage) {
        let imageView = UIImageView(image: icon)
        imageView.frame = CGRect(x: 0, y: 0, width: option.iconSize, height: option.iconSize)
        imageView.changeColor(to: option.iconColor)
        
        leftView = imageView
        leftViewMode = .always
        
        addGesture(to: imageView, selector: #selector(didPressLeftIcon))
        leftIcon = imageView
    }
    
    @objc private func didPressLeftIcon(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        raDelegate?.didPressLeftIcon?(imageView: imageView)
    }
    
    
    
    // Right Icon
    
    private func setupRightIcon(_ icon: UIImage) {
        let imageView = UIImageView(image: icon)
        imageView.frame = CGRect(x: 0, y: 0, width: option.iconSize, height: option.iconSize)
        imageView.changeColor(to: option.iconColor)
        
        rightView = imageView
        rightViewMode = .always
        
        addGesture(to: imageView, selector: #selector(didPressRightIcon))
        rightIcon = imageView
    }
    
    @objc private func didPressRightIcon(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        raDelegate?.didPressRightIcon?(imageView: imageView)
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
        var x: CGFloat = 0
        if let icon = leftIcon, isFirstResponder == false, text?.isEmpty == true {
            x = icon.frame.width + option.leftPadding
        }
        let newRect = CGRect(x: x,
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
    
    private func getTextArea(bounds: CGRect) -> CGRect {
        var frame = bounds
        if let padding = prefixLabel?.frame.width {
            frame.origin.x = padding + option.leftPadding
            frame.size.width = frame.size.width - frame.origin.x
        }
        
        if let padding = suffixLabel?.frame.width {
            frame.size.width = frame.size.width - padding - frame.origin.x - option.rightPadding
        }
        
        if let padding = leftIcon?.frame.width {
            frame.origin.x = padding + option.leftPadding
            frame.size.width = frame.size.width - frame.origin.x
        }
        
        if let padding = rightIcon?.frame.width {
            frame.size.width = frame.size.width - padding - frame.origin.x - option.rightPadding
        }

        return frame
    }
    
    private func addGesture(to view: UIView?, selector: Selector) {
        guard let view = view else { return }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        view.isUserInteractionEnabled = true
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

@objc protocol RATextFieldDelegate: UITextFieldDelegate {
    @objc optional func didPressPrefix(label: UILabel)
    @objc optional func didPressSuffix(label: UILabel)
    @objc optional func didPressLeftIcon(imageView: UIImageView)
    @objc optional func didPressRightIcon(imageView: UIImageView)
}
