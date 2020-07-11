//
//  MoveLeftRightHalfCalculation.swift
//  Boxed
//
//  Created by Ankith on 7/2/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class MoveLeftRightCalculation: WindowCalculation {
    
    override func calculate(_ window: Window, lastAction: BoxedAction?, usableScreens: UsableScreens, action: WindowAction) -> WindowCalculationResult? {
        
        if action == .moveLeft {
            return calculateLeft(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        } else if action == .moveRight {
            return calculateRight(window, lastAction: lastAction, screen: usableScreens.currentScreen, usableScreens: usableScreens)
        }
        
        return nil
    }
    
    func calculateLeft(_ window: Window, lastAction: BoxedAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        
        if Defaults.subsequentExecutionMode.traversesDisplays {
            
            if let lastAction = lastAction, lastAction.action == .moveLeft {
                let normalizedLastRect = AccessibilityElement.normalizeCoordinatesOf(lastAction.rect, frameOfScreen: usableScreens.frameOfCurrentScreen)
                if normalizedLastRect == window.rect {
                    if let prevScreen = usableScreens.adjacentScreens?.prev {
                        return calculateRight(window, lastAction: lastAction, screen: prevScreen, usableScreens: usableScreens)
                    }
                }
            }
        }

        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.minX
        
        if window.rect.height >= visibleFrameOfScreen.height {
            calculatedWindowRect.size.height = visibleFrameOfScreen.height
            calculatedWindowRect.origin.y = visibleFrameOfScreen.minY
        } else if Defaults.centeredDirectionalMove.enabled != false {
            calculatedWindowRect.origin.y = round((visibleFrameOfScreen.height - window.rect.height) / 2.0) + visibleFrameOfScreen.minY
        }
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveLeft)
        
    }
    
    
    func calculateRight(_ window: Window, lastAction: BoxedAction?, screen: NSScreen, usableScreens: UsableScreens) -> WindowCalculationResult? {
        
        if Defaults.subsequentExecutionMode.traversesDisplays {
            
            if let lastAction = lastAction, lastAction.action == .moveRight {
                let normalizedLastRect = AccessibilityElement.normalizeCoordinatesOf(lastAction.rect, frameOfScreen: usableScreens.frameOfCurrentScreen)
                if normalizedLastRect == window.rect {
                    if let nextScreen = usableScreens.adjacentScreens?.next {
                        return calculateLeft(window, lastAction: lastAction, screen: nextScreen, usableScreens: usableScreens)
                    }
                }
            }
        }
        
        let visibleFrameOfScreen = screen.visibleFrame
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.x = visibleFrameOfScreen.maxX - window.rect.width
        
        if window.rect.height >= visibleFrameOfScreen.height {
            calculatedWindowRect.size.height = visibleFrameOfScreen.height
            calculatedWindowRect.origin.y = visibleFrameOfScreen.minY
        } else if Defaults.centeredDirectionalMove.enabled != false {
            calculatedWindowRect.origin.y = round((visibleFrameOfScreen.height - window.rect.height) / 2.0) + visibleFrameOfScreen.minY
        }
        return WindowCalculationResult(rect: calculatedWindowRect, screen: screen, resultingAction: .moveRight)

    }
    
    // unused
    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        return RectResult(CGRect.null)
    }
    
}
