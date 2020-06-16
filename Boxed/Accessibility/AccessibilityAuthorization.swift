//
//  AccessibilityAuthorization.swift
//  Boxed
//
//  Created by Ankith on 6/6/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation
import Cocoa

class AccessibilityAuthorization {
    private var accessibilityWindowController: NSWindowController?
    
    public func checkAccessibility(completion: @escaping () -> Void) -> Bool {
        if !AXIsProcessTrusted() {
            accessibilityWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "AccessibiilityWindowController") as? NSWindowController
            NSApp.activate(ignoringOtherApps: true)
            accessibilityWindowController?.showWindow(self)
            accessibilityWindowController?.window?.makeKey()
            pollAccessibility(completion: completion)
            return false
        } else {
            return true
        }
    }
    
    private func pollAccessibility(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if AXIsProcessTrusted() {
                self.accessibilityWindowController?.close()
                self.accessibilityWindowController = nil
                completion()
            } else {
                self.pollAccessibility( completion: completion )
            }
        }
    }
    
    func showAuthorizationWindow() {
        if accessibilityWindowController?.window?.isMiniaturized == true {
                accessibilityWindowController?.window?.deminiaturize(self)
            }
            NSApp.activate(ignoringOtherApps: true)
        }
}
