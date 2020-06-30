//
//  UpperRightCalculation.swift
//  Boxed
//
//  Created by Ankith on 6/29/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class UpperRightCalculation: WindowCalculation, RepeatedExecutionsCalculation {

    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {

        if lastAction == nil || !Defaults.subsequentExecutionMode.resizes {
            return calculateFirstRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
        }
        
        return calculateRepeatedRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
    }
    
    func calculateFirstRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        var oneQuarterRect = visibleFrameOfScreen
        oneQuarterRect.size.width = floor(visibleFrameOfScreen.width / 2.0)
        oneQuarterRect.size.height = floor(visibleFrameOfScreen.height / 2.0)
        oneQuarterRect.origin.x += oneQuarterRect.width
        oneQuarterRect.origin.y = visibleFrameOfScreen.minY + floor(visibleFrameOfScreen.height / 2.0) + (visibleFrameOfScreen.height.truncatingRemainder(dividingBy: 2.0))
        return RectResult(oneQuarterRect)
    }
    
    func calculateSecondRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.width = floor(visibleFrameOfScreen.width * 2 / 3.0)
        twoThirdsRect.origin.x = visibleFrameOfScreen.minX + visibleFrameOfScreen.width - twoThirdsRect.width
        twoThirdsRect.size.height = floor(visibleFrameOfScreen.height / 2.0)
        twoThirdsRect.origin.y = visibleFrameOfScreen.minY + floor(visibleFrameOfScreen.height / 2.0) + (visibleFrameOfScreen.height.truncatingRemainder(dividingBy: 2.0))
        return RectResult(twoThirdsRect)
    }
    
    func calculateThirdRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        var oneThirdRect = visibleFrameOfScreen
        oneThirdRect.size.width = floor(visibleFrameOfScreen.width / 3.0)
        oneThirdRect.origin.x = visibleFrameOfScreen.minX + visibleFrameOfScreen.width - oneThirdRect.width
        oneThirdRect.size.height = floor(visibleFrameOfScreen.height / 2.0)
        oneThirdRect.origin.y = visibleFrameOfScreen.minY + floor(visibleFrameOfScreen.height / 2.0) + (visibleFrameOfScreen.height.truncatingRemainder(dividingBy: 2.0))
        return RectResult(oneThirdRect)
    }
}
