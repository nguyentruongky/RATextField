//
//  ViewController.swift
//  RedAirship
//
//  Created by Ky Nguyen on 3/12/21.
//

import UIKit

class DemoController: UITableViewController {
    var dataSource = [UITableViewCell]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let titleWithFormatTextField = RATextField(label: "Username",
                                               option: RATextField.FormatOption(
                                                titleColor: UIColor.blue,
                                                iconColor: UIColor.brown))
    let errorTextField = RATextField(label: "Username")
    let helperTextField = RATextField(label: "Password")
    let staticTextField = RATextField(label: "Static text")
    let prefixTextField = RATextField(prefix: "+84")
    let suffixTextField = RATextField(suffix: "CUR")
    let leftIconTextField = RATextField(leftIcon: UIImage(named: "mail")!)
    let rightIconTextField = RATextField(rightIcon: UIImage(named: "check-mark")!)
    let textLinkTextField = RATextField(label: "Hello text link", textLink: "See more")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        setupview()
        
        prefixTextField.raDelegate = self
        suffixTextField.raDelegate = self
        leftIconTextField.raDelegate = self
        rightIconTextField.raDelegate = self
        textLinkTextField.raDelegate = self
    }
    
    // ignore
    func setupview() {
        tableView.keyboardDismissMode = .interactive
        
        let errorCell = createTextCell(textField: errorTextField,
                                       buttonTitle: "Toggle error",
                                       action: #selector(toggleError))
        let helperCell = createTextCell(textField: helperTextField,
                                        buttonTitle: "Toggle Helper",
                                        action: #selector(toggleHelper))
        let staticCell = createTextCell(textField: staticTextField,
                                        buttonTitle: "Toggle Static",
                                        action: #selector(toggleStatic))
        let prefixCell = createTextCell(textField: prefixTextField)
        prefixTextField.text = "Hello static text"
        prefixTextField.setStatic(isEnabled: true)
        let suffixCell = createTextCell(textField: suffixTextField)
        let leftIconCell = createTextCell(textField: leftIconTextField)
        leftIconTextField.setTitle("Left icon title")
        
        let rightIconCell = createTextCell(textField: rightIconTextField)
        rightIconTextField.setTitle("Email")
        rightIconTextField.setHelper(visible: true, content: "Your redairship email")
        
        let textLinkCell = createTextCell(textField: textLinkTextField)
        
        dataSource = [
            errorCell,
            helperCell,
            staticCell,
            prefixCell,
            suffixCell,
            leftIconCell,
            rightIconCell,
            textLinkCell
        ]
    }
    
    // ignore
    func createTextCell(textField: RATextField, buttonTitle: String? = nil, action: Selector? = nil) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        if let action = action {
            let button = UIButton(title: buttonTitle)
            button.addTarget(self, action: action)
            
            cell.contentView.addSubviews(views: textField, button)
            cell.contentView.stackVertically(views: [textField, button],
                                             viewSpaces: 32,
                                             topSpace: 32,
                                             bottomSpace: 16)
            
            textField.horizontalSuperview(space: 16)
            button.centerXToSuperview()
        } else {
            cell.contentView.addSubviews(views: textField)
            textField.fillSuperView(space: UIEdgeInsets(space: 16))
        }
        
        textField.height(64)
        return cell
    }
    
    @objc func toggleError(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            // notice
            errorTextField.setError(visible: true, content: "Your username was registered")
        } else {
            // notice
            errorTextField.setError(visible: false)
        }
    }
    
    @objc func toggleHelper(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            // notice
            helperTextField.setHelper(visible: true, content: "Password must have 8 letters at least")
        } else {
            // notice
            helperTextField.setHelper(visible: false)
        }
    }

    @objc func toggleStatic(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            // notice
            staticTextField.setStatic(isEnabled: true, helper: "This is the static helper")
        } else {
            // notice
            staticTextField.setStatic(isEnabled: false)
        }
    }
}

// ignore
extension DemoController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource[indexPath.row]
    }
}

extension DemoController: RATextFieldDelegate {
    func didPressPrefix(label: UILabel) {
        print("hello prefix")
        label.text = "+65"
    }
    
    func didPressSuffix(label: UILabel) {
        print("hello suffix")
        label.text = "Change"
    }
    
    func didPressLeftIcon(imageView: UIImageView) {
        print("Hello left icon")
    }
    
    func didPressRightIcon(imageView: UIImageView) {
        print("hello right icon")
    }
    
    func didPressTextLink(textLink: UIButton) {
        print("Hello textlink")
    }
}
