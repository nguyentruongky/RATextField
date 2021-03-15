//
//  TDTouchableView.swift
//  ios-doctor
//
//  Created on 3/28/20
//  Copyright © 2020 Jun Ho Hong. All rights reserved. 
//

import UIKit
enum TDTouchableViewType {
    case opaque
    case opacity
    case bounce
}

class TDTouchableView: KNView {
    override var isUserInteractionEnabled: Bool {
        get { return true }
        set { }
    }
    lazy var toucher = TDToucher(view: self)
    convenience init(type: TDTouchableViewType) {
        self.init(frame: .zero)
        toucher.touchableType = type
    }
    var tapGesture: UITapGestureRecognizer?
    var selectBlock: (() -> Void)? {
        didSet {
            if let gesture = tapGesture {
                removeGestureRecognizer(gesture)
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pressed))
            self.addGestureRecognizer(tapGesture)
            self.tapGesture = tapGesture
        }
    }
    
    @objc func pressed() {
        toucher.animate(isTouchingDown: true)
        self.selectBlock?()
    }
}


// MARK: Animation
class TDToucher {
    var touchableType: TDTouchableViewType = .opaque
    weak var view: UIView?
    init(view: UIView) {
        self.view = view
    }
    func animate(isTouchingDown: Bool) {
        if touchableType == .opaque { return }
        if touchableType == .opacity {
            animateAlpha(isTouchingDown: isTouchingDown)
        } else if touchableType == .bounce {
            bounce(isTouchingDown: isTouchingDown)
        }
    }
    func animateAlpha(isTouchingDown: Bool) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
            self?.view?.alpha = isTouchingDown ? 0.5 : 1
            }, completion: { [weak self] _ in
                if isTouchingDown {
                    self?.animateAlpha(isTouchingDown: false)
                }
        })
    }
    func bounce(isTouchingDown: Bool) {
        UIView.animate(withDuration: 0.22, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
            if isTouchingDown {
                self?.view?.alpha = 0.9
                self?.view?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self?.view?.alpha = 1
                self?.view?.transform = CGAffineTransform.identity
            }
        }, completion: { [weak self] _ in
                if isTouchingDown {
                    self?.bounce(isTouchingDown: false)
                }
        })
    }
}


class TDTouchableImageView: TDTouchableView {
    let holder = UIImageView()
    convenience init(type: TDTouchableViewType, imageName: String) {
        self.init(frame: .zero)
        toucher.touchableType = type
        holder.image = UIImage(named: imageName)
    }
    convenience init(type: TDTouchableViewType, image: UIImage) {
        self.init(frame: .zero)
        toucher.touchableType = type
        holder.image = image
    }
    override func setupView() {
        addSubviews(views: holder)
        holder.fillSuperView()
    }
}


class TDTouchableLabel: TDTouchableView {
    private(set) var holder = UILabel()
    convenience init(type: TDTouchableViewType, label: UILabel) {
        self.init(frame: .zero)
        toucher.touchableType = type
        holder = label
        setupView()
    }
    override func setupView() {
        addSubviews(views: holder)
        holder.fillSuperView()
    }
}


class TDTouchableButton: TDTouchableView {
    private(set) var holder = UILabel()
    var isEnabled: Bool = true {
        didSet {
            isUserInteractionEnabled = isEnabled
        }
    }
    convenience init(type: TDTouchableViewType, title: String, font: UIFont? = nil, textColor: UIColor? = nil) {
        self.init(frame: .zero)
        toucher.touchableType = type
        holder.text = title
        holder.textAlignment = .center
        holder.font = font
        holder.textColor = textColor
    }
    
    @objc func runBlock() {
        selectBlock?()
    }
    override func setupView() {
        addSubviews(views: holder)
        holder.horizontalSuperview()
        holder.centerYToSuperview()
    }
}
