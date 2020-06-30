//
//  AppDelegate.swift
//  BoxedLauncher
//
//  Created by Ankith on 6/3/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = "com.monkeyank.Boxed"
        let running = NSWorkspace.shared.runningApplications
        let isRunning = !running.filter({$0.bundleIdentifier == mainAppIdentifier}).isEmpty
        
        if isRunning {
            self.terminate()
        } else {
            let killNotification = Notification.Name("killLauncher")
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: killNotification, object:mainAppIdentifier)
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("Boxed")
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared.launchApplication(newPath)
        }
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}


