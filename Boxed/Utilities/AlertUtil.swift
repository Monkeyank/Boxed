//
//  AlertUtil.swift
//  Boxed
//
//  Created by Ankith on 6/3/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class AlertUtil {
    
    // Alert Extension/Util to be used around the codebase
    
    static func oneButtonAlert(question: String, text: String, confirmText: String = "OK") {
        let alert = NSAlert()
        alert.messageText = question
        alert.alertStyle = .warning
        alert.informativeText = text
        alert.addButton(withTitle: confirmText)
        alert.runModal()
    }
}
