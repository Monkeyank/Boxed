//
//  WindowCalculations.swift
//  Boxed
//
//  Created by Ankith on 6/8/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

protocol Calculation {
    func calculate(_ window: Window, lastAction: BoxedAction?, usableScreens: UsableScreens, action: WindowAction) -> WindowCalculationResult?
    
    func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult
}

class WindowCalculation: Calculation {
    
    func calculate(_ window: Window, lastAction: BoxedAction?, usableScreens: UsableScreens, action: WindowAction) -> WindowCalculationResult? {
        
        let rectResult = calculateRect(window, lastAction: lastAction, visibleFrameOfScreen: usableScreens.currentScreen.visibleFrame, action: action)
        
        if rectResult.rect.isNull {
            return nil
        }
        
        return WindowCalculationResult(rect: rectResult.rect, screen: usableScreens.currentScreen, resultingAction: action, resultingSubAction: rectResult.subAction)
    }
    
    func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        return RectResult(CGRect.null)
    }
    
    func rectCenteredWithinRect(_ rect1: CGRect, _ rect2: CGRect) -> Bool {
        let centeredMidX = abs(rect2.midX - rect1.midX) <= 1.0
        let centeredMidY = abs(rect2.midY - rect1.midY) <= 1.0
        return rect1.contains(rect2) && centeredMidX && centeredMidY
    }
    
    func rectFitsWithinRect(rect1: CGRect, rect2: CGRect) -> Bool {
        return (rect1.width <= rect2.width) && (rect1.height <= rect2.height)
    }
    
    func isLandscape(_ rect: CGRect) -> Bool {
        return rect.width > rect.height
    }
    
}

struct RectResult {
    let rect: CGRect
    let subAction: SubWindowAction?
    
    init(_ rect: CGRect, subAction: SubWindowAction? = nil) {
        self.rect = rect
        self.subAction = subAction
    }
}

struct Window {
    let id: Int
    let rect: CGRect
}

struct WindowCalculationResult {
    var rect: CGRect
    let screen: NSScreen
    let resultingAction: WindowAction
    let resultingSubAction: SubWindowAction?
    
    init(rect: CGRect, screen: NSScreen, resultingAction: WindowAction,  resultingSubAction: SubWindowAction? = nil) {
        self.rect = rect
        self.screen = screen
        self.resultingAction = resultingAction
        self.resultingSubAction = resultingSubAction
    }
}

class WindowCalculationFactory {
    
    let bottomHalfCalculation = BottomHalfCalculation()
    let topHalfCalculation = TopHalfCalculation()
    let centerCalculation = CenterCalculation()
    let nextPreviousDisplayCalculation = NextPreviousDisplayCalculation()
    let maximizeCalculation = MaximizeCalculation()
    let changeSizeCalculation = ChangeSizeCalculation()
    let almostMaximizeCalculation = AlmostMaximizeCalculation()
    let maxHeightCalculation = MaximizeHeightCalculation()
    
    func calculation(for action: WindowAction) -> WindowCalculation? {
        switch action {
        case .maximizeHeight: return maxHeightCalculation
        case .previousDisplay: return nextPreviousDisplayCalculation
        case .nextDisplay: return nextPreviousDisplayCalculation
        case .larger: return changeSizeCalculation
        case .smaller: return changeSizeCalculation
        case .bottomHalf: return bottomHalfCalculation
        case .topHalf: return topHalfCalculation
        case .center: return centerCalculation
        case .almostMaximize: return almostMaximizeCalculation
        default: return nil
        }
    }
}
