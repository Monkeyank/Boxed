//
//  PrefsViewController.swift
//  Boxed
//
//  Created by Ankith on 6/3/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa
import MASShortcut
import ServiceManagement

class PrefsViewController: NSViewController {
    
    var actionsToViews = [WindowAction: MASShortcutView]()

    // Shortcut buttons/list
    
    @IBOutlet weak var leftHalfShortcutView: MASShortcutView!
    @IBOutlet weak var rightHalfShortcutView: MASShortcutView!
    @IBOutlet weak var topHalfShortcutView: MASShortcutView!
    @IBOutlet weak var bottomHalfShortcutView: MASShortcutView!
    
    @IBOutlet weak var topLeftShortcutView: MASShortcutView!
    @IBOutlet weak var topRightShortcutView: MASShortcutView!
    
    // Settings Views/Replaceable things
    
    override func awakeFromNib() {
        
        actionsToViews = [
            .leftHalf: leftHalfShortcutView,
            .rightHalf: rightHalfShortcutView,
            .topHalf: topHalfShortcutView,
            .bottomHalf: bottomHalfShortcutView,
            .topLeft: topLeftShortcutView,
            .topRight: topRightShortcutView,
        ]
        
        for (action, view) in actionsToViews {
            view.associatedUserDefaultsKey = action.name
        }
        
        if Defaults.allowAnyShortcut.enabled {
            let passThroughValidator = PassthroughShortcutValidator()
            actionsToViews.values.forEach { $0.shortcutValidator = passThroughValidator }
        }
        
        subscribeToAllowAnyShortcutToggle()
    }
    
    private func subscribeToAllowAnyShortcutToggle() {
        NotificationCenter.default.addObserver(self, selector: #selector(allowAnyShortcutToggled), name: SettingsViewController.allowAnyShortcutNotificationName, object: nil)
    }
    
    @objc func allowAnyShortcutToggled(notification: Notification) {
        guard let enabled = notification.object as? Bool else { return }
        let validator = enabled ? PassthroughShortcutValidator() : MASShortcutValidator()
        actionsToViews.values.forEach { $0.shortcutValidator = validator }
    }
}

// Validates Shortcut and Allows them to be Called

class PassthroughShortcutValidator: MASShortcutValidator {
    
    override func isShortcutValid(_ shortcut: MASShortcut!) -> Bool {
        return true
    }
    
    override func isShortcutAlreadyTaken(bySystem shortcut: MASShortcut!, explanation: AutoreleasingUnsafeMutablePointer<NSString?>!) -> Bool {
        return false
    }
    
    override func isShortcut(_ shortcut: MASShortcut!, alreadyTakenIn menu: NSMenu!, explanation: AutoreleasingUnsafeMutablePointer<NSString?>!) -> Bool {
        return false
    }
    
}
