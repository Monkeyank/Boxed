//
//  NextPreviousDisplayCalculation.swift
//  Boxed
//
//  Created by Ankith on 6/13/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class NextPreviousDisplayCalculation: WindowCalculation {
    
    let centerCalculation = CenterCalculation()
    
    override func calculate(_ window: Window, lastAction: BoxedAction?, usableScreens: UsableScreens, action: WindowAction) -> WindowCalculationResult? {
        
        guard usableScreens.numScreens > 1 else { return nil }

        var screen: NSScreen?
        
        if action == .nextDisplay {
            screen = usableScreens.adjacentScreens?.next
        } else if action == .previousDisplay {
            screen = usableScreens.adjacentScreens?.prev
        }

        if let screen = screen {
            let rectResult = calculateRect(window, lastAction: lastAction, visibleFrameOfScreen: NSRectToCGRect(screen.visibleFrame), action: action)
            return WindowCalculationResult(rect: rectResult.rect, screen: screen, resultingAction: action)
        }
        
        return nil
    }
    
    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        return centerCalculation.calculateRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
    }
}

