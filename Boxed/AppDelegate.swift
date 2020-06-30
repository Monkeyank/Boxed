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
    private let accessibilityAuthorization = AccessibilityAuthorization()
        private let statusItem = BoxedStatusItem.instance
        private let windowHistory = WindowHistory()
        
        private var shortcutManager: ShortcutManager!
        private var windowManager: WindowManager!
        private var applicationToggle: ApplicationToggle!
        private var windowCalculationFactory: WindowCalculationFactory!
        private var snappingManager: SnappingManager!
        
        private var prefsWindowController: NSWindowController?
        
        @IBOutlet weak var mainStatusMenu: NSMenu!
        @IBOutlet weak var unauthorizedMenu: NSMenu!
        @IBOutlet weak var ignoreMenuItem: NSMenuItem!
        @IBOutlet weak var viewLoggingMenuItem: NSMenuItem!
        @IBOutlet weak var quitMenuItem: NSMenuItem!
        
        func applicationDidFinishLaunching(_ aNotification: Notification) {
            mainStatusMenu.delegate = self
            statusItem.refreshVisibility()
            checkLaunchOnLogin()
            
            let alreadyTrusted = accessibilityAuthorization.checkAccessibility {
                self.showWelcomeWindow()
                self.checkForConflictingApps()
                self.openPreferences(self)
                self.statusItem.statusMenu = self.mainStatusMenu
                self.accessibilityTrusted()
            }
            
            if alreadyTrusted {
                accessibilityTrusted()
            }
            
            statusItem.statusMenu = alreadyTrusted
                ? mainStatusMenu
                : unauthorizedMenu
            
            mainStatusMenu.autoenablesItems = false
            addWindowActionMenuItems()
        }
        
        func accessibilityTrusted() {
            self.windowCalculationFactory = WindowCalculationFactory()
            self.windowManager = WindowManager(windowCalculationFactory: windowCalculationFactory, windowHistory: windowHistory)
            self.shortcutManager = ShortcutManager(windowManager: windowManager)
            self.applicationToggle = ApplicationToggle(shortcutManager: shortcutManager)
            self.snappingManager = SnappingManager(windowCalculationFactory: windowCalculationFactory, windowHistory: windowHistory)
        }
        
        func checkForConflictingApps() {
            let conflictingAppsIds: [String: String] = [
                "com.divisiblebyzero.Spectacle": "Spectacle",
                "com.crowdcafe.windowmagnet": "Magnet",
                "com.hegenberg.BetterSnapTool": "BetterSnapTool",
                "com.manytricks.Moom": "Moom"
            ]
            
            let runningApps = NSWorkspace.shared.runningApplications
            for app in runningApps {
                guard let bundleId = app.bundleIdentifier else { continue }
                if let conflictingAppName = conflictingAppsIds[bundleId] {
                    AlertUtil.oneButtonAlert(question: "Potential window manager conflict: \(conflictingAppName)", text: "Since \(conflictingAppName) might have some overlapping behavior with Boxed, it's recommended that you either disable or quit \(conflictingAppName).")
                    break
                }
            }
            
        }
        
        private func showWelcomeWindow() {
            let welcomeWindowController = NSStoryboard(name: "Main", bundle: nil)
                .instantiateController(withIdentifier: "WelcomeWindowController") as? NSWindowController
            guard let welcomeWindow = welcomeWindowController?.window else { return }
            welcomeWindow.delegate = self
            
            NSApp.activate(ignoringOtherApps: true)
            
            let response = NSApp.runModal(for: welcomeWindow)
            
            let usingRecommended = response == .alertFirstButtonReturn || response == .abort
            
            Defaults.alternateDefaultShortcuts.enabled = usingRecommended
            
            Defaults.subsequentExecutionMode.value = usingRecommended ? .acrossMonitor : .resize
            
            welcomeWindowController?.close()
        }
        
        func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
            if Defaults.relaunchOpensMenu.enabled {
                statusItem.openMenu()
            } else {
                openPreferences(sender)
            }
            return true
        }
        
        @IBAction func openPreferences(_ sender: Any) {
            if prefsWindowController == nil {
                prefsWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PrefsWindowController") as? NSWindowController
            }
            NSApp.activate(ignoringOtherApps: true)
            prefsWindowController?.showWindow(self)
            prefsWindowController?.window?.makeKey()
        }
        
        @IBAction func showAbout(_ sender: Any) {
            NSApp.activate(ignoringOtherApps: true)
            NSApp.orderFrontStandardAboutPanel(sender)
        }
        
        @IBAction func viewLogging(_ sender: Any) {
            Logger.showLogging(sender: sender)
        }
        
        @IBAction func ignoreFrontMostApp(_ sender: NSMenuItem) {
            if sender.state == .on {
                applicationToggle.enableFrontApp()
            } else {
                applicationToggle.disableFrontApp()
            }
        }
        
        @IBAction func checkForUpdates(_ sender: Any) {
            SUUpdater.shared()?.checkForUpdates(sender)
        }
        
        @IBAction func authorizeAccessibility(_ sender: Any) {
            accessibilityAuthorization.showAuthorizationWindow()
        }

        private func checkLaunchOnLogin() {
            let running = NSWorkspace.shared.runningApplications
            let isRunning = !running.filter({$0.bundleIdentifier == AppDelegate.launcherAppId}).isEmpty
            if isRunning {
                let killNotification = Notification.Name("killLauncher")
                DistributedNotificationCenter.default().post(name: killNotification, object: Bundle.main.bundleIdentifier!)
            }
            
            // Even if we are already set up to launch on login, setting it again since macOS can be buggy with this type of launch on login.
            if Defaults.launchOnLogin.enabled {
                let smLoginSuccess = SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, true)
                if !smLoginSuccess {
                    if #available(OSX 10.12, *) {
                        os_log("Unable to enable launch at login. Attempting one more time.", type: .info)
                    }
                    SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, true)
                }
            }
        }
        
    }

    extension AppDelegate: NSMenuDelegate {
        
        func menuWillOpen(_ menu: NSMenu) {
            if let frontAppName = applicationToggle.frontAppName {
                let ignoreString = NSLocalizedString("D99-0O-MB6.title", tableName: "Main", value: "Ignore frontmost.app", comment: "")
                ignoreMenuItem.title = ignoreString.replacingOccurrences(of: "frontmost.app", with: frontAppName)
                ignoreMenuItem.state = applicationToggle.shortcutsDisabled ? .on : .off
                ignoreMenuItem.isHidden = false
            } else {
                ignoreMenuItem.isHidden = true
            }
            
            let frontmostWindow = AccessibilityElement.frontmostWindow()
            let screenCount = NSScreen.screens.count
            
            for menuItem in menu.items {
                guard let windowAction = menuItem.representedObject as? WindowAction else { continue }

                menuItem.image = windowAction.image
                menuItem.image?.size = NSSize(width: 18, height: 12)

                if !applicationToggle.shortcutsDisabled {
                    if let fullKeyEquivalent = shortcutManager.getKeyEquivalent(action: windowAction),
                        let keyEquivalent = fullKeyEquivalent.0?.lowercased() {
                        menuItem.keyEquivalent = keyEquivalent
                        menuItem.keyEquivalentModifierMask = fullKeyEquivalent.1
                    }
                }
                if frontmostWindow == nil {
                    menuItem.isEnabled = false
                }
                if screenCount == 1
                    && (windowAction == .nextDisplay || windowAction == .previousDisplay) {
                    menuItem.isEnabled = false
                }
            }
            
            viewLoggingMenuItem.keyEquivalentModifierMask = .option
            quitMenuItem.keyEquivalent = "q"
            quitMenuItem.keyEquivalentModifierMask = .command
        }
        
        func menuDidClose(_ menu: NSMenu) {
            for menuItem in menu.items {
                
                menuItem.keyEquivalent = ""
                menuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags()
                
                menuItem.isEnabled = true
            }
        }
        
        func addWindowActionMenuItems() {
            var menuIndex = 0
            for action in WindowAction.active {
                if menuIndex != 0 && action.firstInGroup {
                    mainStatusMenu.insertItem(NSMenuItem.separator(), at: menuIndex)
                    menuIndex += 1
                }
                
                let newMenuItem = NSMenuItem(title: action.displayName, action: #selector(executeMenuWindowAction), keyEquivalent: "")
                newMenuItem.representedObject = action
                mainStatusMenu.insertItem(newMenuItem, at: menuIndex)
                menuIndex += 1
            }
            mainStatusMenu.insertItem(NSMenuItem.separator(), at: menuIndex)
        }
        
        @objc func executeMenuWindowAction(sender: NSMenuItem) {
            guard let windowAction = sender.representedObject as? WindowAction else { return }
            windowAction.post()
        }
        
    }

    extension AppDelegate: NSWindowDelegate {
        
        func windowWillClose(_ notification: Notification) {
            NSApp.abortModal()
        }
        
    }
