//
//  AcessibilityWindowController.swift
//  Boxed
//
//  Created by Ankith on 6/6/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class AccessibilityWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let closeButton = self.window?.standardWindowButton(.closeButton)
        closeButton?.target = self
        closeButton?.action = #selector(quit)
    }
    
    @objc func quit() {
        exit(1)
    }
}



class AccessibilityViewController: NSViewController {
    
    @IBAction func openSystemPrefs(_ sender: Any) {
        NSWorkspace.shared.open(URL(string:"x-apple.systempreferences:com.apple.preference.security?Privacy_Accesibility")!)
    }
}
