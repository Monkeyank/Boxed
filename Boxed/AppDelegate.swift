//
//  AppDelegate.swift
//  Boxed
//
//  Created by Ankith on 6/2/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa
import Sparkle
import ServiceManagement
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static let launcherAppId = "com.monkeyank.BoxedLauncher"
}

extension AppDelegate: NSMenuDelegate {
    
}

extension AppDelegate: NSWindowDelegate {
    
}
