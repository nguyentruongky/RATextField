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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupview()
    }
    let errorTextField = RATextField(label: "Username")
    let helperTextField = RATextField(label: "Password")
    let staticTextField = RATextField(label: "Static text")

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
        
        dataSource = [
            errorCell,
            helperCell,
            staticCell
        ]
    }
    
    // ignore
    func createTextCell(textField: RATextField, buttonTitle: String, action: Selector) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        let button = UIButton(title: buttonTitle)
        button.addTarget(self, action: action)
        
        cell.contentView.addSubviews(views: textField, button)
        cell.contentView.stackVertically(views: [textField, button],
                                         viewSpaces: 32,
                                         topSpace: 32,
                                         bottomSpace: 16)
        textField.height(44)
        textField.horizontalSuperview(space: 16)
        button.centerXToSuperview()
        
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
            helperTextField.setError(visible: false)
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

extension DemoController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource[indexPath.row]
    }
}


