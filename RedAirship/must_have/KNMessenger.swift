//
//  Messenger.swift
//  knStore
//
//  Created by Ky Nguyen on 8/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import SwiftyDrop

struct Messenger {
    static let defaultError = "Something went wrong"
    static func getMessage(_ message: String?, title: String?,
                            cancelActionName: String? = "OK") -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelActionName != nil {
            controller.addAction(UIAlertAction(title: cancelActionName, style: .destructive, handler: nil))
        }
        return controller
    }

    static func presentMessage(_ message: String?, title: String? = nil,
                            cancelActionName: String? = "OK") {
        let controller = getMessage(message, title: title, cancelActionName: cancelActionName)
        UIApplication.topViewController()?.present(controller)
    }

    static func showError(_ message: String) {
        Drop.down(message, state: .error, duration: 3)
    }

    static func showMessage(_ message: String) {
        Drop.down(message, state: .info, duration: 3)
    }

}

