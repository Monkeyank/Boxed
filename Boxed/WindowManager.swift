//
//  WindowManager.swift
//  Boxed
//
//  Created by Ankith on 6/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class WindowManager {
    
    private let gapSize = Defaults.gapSize.value
    private let fixedSizeWindowMoverChain: [WindowMover]
    private let standardWindowMoverChain: [WindowMover]
    private let screenDetection = ScreenDetection()
    private let windowCalculationFactory: WindowCalculationFactory
    private let windowHistory: WindowHistory
    
    init(windowCalculationFactory: WindowCalculationFactory, windowHistory: WindowHistory) {
        self.windowCalculationFactory = windowCalculationFactory
        self.windowHistory = windowHistory
        standardWindowMoverChain = [
            StandardWindowMover(),
            BestWindowMover()
        ]
        
        fixedSizeWindowMoverChain = [
            CenteringFixedSizeWindowMover(),
            BestWindowMover()
        ]
    }
    
    func execute(_ parameters: ExecutionParameters) {
        guard let frontmostWindowElement = AccessibilityElement.frontmostWindow(),
            let windowId = frontmostWindowElement.getIdentifier()
        else {
            NSSound.beep()
            return
        }
        
        let action = parameters.action
        
        if action == .restore {
            if let restoreRect = windowHistory.restoreRects[windowId] {
                frontmostWindowElement.setRectOf(restoreRect)
            }
            windowHistory.lastBoxedActions.removeValue(forKey: windowId)
            return
        }
        
        var screens: UsableScreens?
        if let screen = parameters.screen {
            screens = UsableScreens(currentScreen: screen, numScreens: 1)
        } else {
            screens = screenDetection.detectScreens(using: frontmostWindowElement)
        }
        
        guard let usableScreens = screens else {
            NSSound.beep()
            Logger.log("Unable to obtain usable screens")
            return
        }
        
        let currentWindowRect: CGRect = frontmostWindowElement.rectOfElement()
        
        let lastBoxedAction = windowHistory.lastBoxedActions[windowId]
        
        if parameters.updateRestoreRect {
            if windowHistory.restoreRects[windowId] == nil
                || currentWindowRect != lastBoxedAction?.rect {
                windowHistory.restoreRects[windowId] = currentWindowRect
            }
        }
        
        if frontmostWindowElement.isSheet()
            || frontmostWindowElement.isSystemDialog()
            || currentWindowRect.isNull
            || usableScreens.frameOfCurrentScreen.isNull
            || usableScreens.visibleFrameOfCurrentScreen.isNull {
            NSSound.beep()
            Logger.log("Window is not snappable or usable screen is not valid")
            return
        }

        let currentNormalizedRect = AccessibilityElement.normalizeCoordinatesOf(currentWindowRect, frameOfScreen: usableScreens.frameOfCurrentScreen)
        let currentWindow = Window(id: windowId, rect: currentNormalizedRect)
        
        let windowCalculation = windowCalculationFactory.calculation(for: action)
        
        guard var calcResult = windowCalculation?.calculate(currentWindow, lastAction: lastBoxedAction, usableScreens: usableScreens, action: action) else {
            NSSound.beep()
            Logger.log("Nil calculation result")
            return
        }
        
        if gapSize > 0, calcResult.resultingAction.gapsApplicable {
            let gapSharedEdges = calcResult.resultingSubAction?.gapSharedEdge ?? calcResult.resultingAction.gapSharedEdge
            
            calcResult.rect = GapCalculation.applyGaps(calcResult.rect, sharedEdges: gapSharedEdges, gapSize: gapSize)
        }

        if currentNormalizedRect.equalTo(calcResult.rect) {
            Logger.log("Current frame is equal to new frame")
            return
        }
        
        let newRect = AccessibilityElement.normalizeCoordinatesOf(calcResult.rect, frameOfScreen: usableScreens.frameOfCurrentScreen)

        let visibleFrameOfDestinationScreen = NSRectToCGRect(calcResult.screen.visibleFrame)

        let useFixedSizeMover = !frontmostWindowElement.isResizable() && action.resizes
        let windowMoverChain = useFixedSizeMover
            ? fixedSizeWindowMoverChain
            : standardWindowMoverChain

        for windowMover in windowMoverChain {
            windowMover.moveWindowRect(newRect, frameOfScreen: usableScreens.frameOfCurrentScreen, visibleFrameOfScreen: visibleFrameOfDestinationScreen, frontmostWindowElement: frontmostWindowElement, action: action)
        }

        let resultingRect = frontmostWindowElement.rectOfElement()
        
        var newCount = 1
        if lastBoxedAction?.action == calcResult.resultingAction,
            let currentCount = lastBoxedAction?.count {
            newCount = currentCount + 1
            newCount %= 3
        }
        
        windowHistory.lastBoxedActions[windowId] = BoxedAction(
            action: calcResult.resultingAction,
            rect: resultingRect,
            count: newCount
        )
        
        if Logger.logging {
            var srcDestScreens: String = ""
            if #available(OSX 10.15, *) {
                srcDestScreens += ", srcScreen: \(usableScreens.currentScreen.localizedName)"
                srcDestScreens += ", destScreen: \(calcResult.screen.localizedName)"
                if let resultScreens = screenDetection.detectScreens(using: frontmostWindowElement) {
                    srcDestScreens += ", resultScreen: \(resultScreens.currentScreen.localizedName)"
                }
            }
            
            Logger.log("\(action.name) | display: \(visibleFrameOfDestinationScreen.debugDescription), calculatedRect: \(newRect.debugDescription), resultRect: \(resultingRect.debugDescription)\(srcDestScreens)")
        }
    }
}

struct BoxedAction {
    let action: WindowAction
    let rect: CGRect
    let count: Int
}

struct ExecutionParameters {
    let action: WindowAction
    let updateRestoreRect: Bool
    let screen: NSScreen?
    
    init(_ action: WindowAction, updateRestoreRect: Bool = true, screen: NSScreen? = nil) {
        self.action = action
        self.updateRestoreRect = updateRestoreRect
        self.screen = screen
    }
}
