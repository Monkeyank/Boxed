//
//  LastTwoThirds.swift
//  Boxed
//
//  Created by Ankith on 7/2/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class LastTwoThirdsCalculation: WindowCalculation {
    
    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        return isLandscape(visibleFrameOfScreen)
            ? RectResult(rightTwoThirds(visibleFrameOfScreen), subAction: .rightTwoThirds)
            : RectResult(bottomTwoThirds(visibleFrameOfScreen), subAction: .bottomTwoThirds)
    }
    
    private func rightTwoThirds(_ visibleFrameOfScreen: CGRect) -> CGRect {
        
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.width = floor(visibleFrameOfScreen.width * 2 / 3.0)
        twoThirdsRect.origin.x = visibleFrameOfScreen.minX + visibleFrameOfScreen.width - twoThirdsRect.width
        return twoThirdsRect
    }
    
    private func bottomTwoThirds(_ visibleFrameOfScreen: CGRect) -> CGRect {
        
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.height = floor(visibleFrameOfScreen.height * 2 / 3.0)
        return twoThirdsRect
    }
}
