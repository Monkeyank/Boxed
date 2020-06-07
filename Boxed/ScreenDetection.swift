//
//  ScreenDetection.swift
//  Boxed
//
//  Created by Ankith on 6/6/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class ScreenDetection {
    
    func detectScreens(using frontmostWindowElement: AccessibilityElement?) -> UsableScreens? {
        let screens = NSScreen.screens
        guard let firstScreen = screens.first else { return nil }
        
        if (screens.count == 1) {
            let adjacentScreens = Defaults.traverseSingleScreen.enabled == true
            ? AdjacentScreens(prev: firstScreen, next: firstScreen)
            : nil
            
            return UsableScreens(currentScreen: firstScreen, adjacentScreens: adjacentScreens, numScreens: screens.count)
        }
    }
    
    struct UsableScreens {
        let currentScreen: NSScreen
        let adjacentScreens: AdjacentScreens?
        let frameOfCurrentScreen: CGRect
        let visibleFrameOfCurrentScreen: CGRect
        let numScreens: Int
        
        init(currentScreen: NSScreen, adjacentScreens: AdjacentScreens? = nil, numScreens: Int) {
            self.currentScreen = currentScreen
            self.adjacentScreens = adjacentScreens
            self.frameOfCurrentScreen = NSRectToCGRect(currentScreen.frame)
            self.visibleFrameOfCurrentScreen =  NSRectToCGRect(currentScreen.visibleFrame)
            self.numScreens = numScreens
        }
    }

    struct AdjacentScreens {
        let prev: NSScreen
        let next: NSScreen
    }
}

struct UsableScreens {
    let frameOfCurrentScreen: CGRect
    let visibleFrameOfCurrentScreen: CGRect
    let numScreens: Int
    let currentScreen: NSScreen
    let adjacentScreens: AdjacentScreens?
    
    init(currentScreen: NSScreen, adjacentScreens: AdjacentScreens? = nil, numScreens: Int) {
        self.currentScreen = currentScreen
        self.adjacentScreens = adjacentScreens
        self.frameOfCurrentScreen = NSRectToCGRect(currentScreen.frame)
        self.visibleFrameOfCurrentScreen =  NSRectToCGRect(currentScreen.visibleFrame)
        self.numScreens = numScreens
    }
}

struct AdjacentScreens {
    let prev: NSScreen
    let next: NSScreen
}
