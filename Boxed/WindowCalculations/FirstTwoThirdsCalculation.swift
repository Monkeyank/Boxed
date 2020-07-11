//
//  FirstTwoThirds.swift
//  Boxed
//
//  Created by Ankith on 7/2/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class FirstTwoThirdsCalculation: WindowCalculation {
    
    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        return isLandscape(visibleFrameOfScreen)
            ? RectResult(leftTwoThirds(visibleFrameOfScreen), subAction: .leftTwoThirds)
            : RectResult(topTwoThirds(visibleFrameOfScreen), subAction: .topTwoThirds)
    }
    
    private func leftTwoThirds(_ visibleFrameOfScreen: CGRect) -> CGRect {
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.width = floor(visibleFrameOfScreen.width * 2 / 3.0)
        return twoThirdsRect
    }
    
    private func topTwoThirds(_ visibleFrameOfScreen: CGRect) -> CGRect {
        var twoThirdsRect = visibleFrameOfScreen
        twoThirdsRect.size.height = floor(visibleFrameOfScreen.height * 2 / 3.0)
        twoThirdsRect.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.height - twoThirdsRect.height
        return twoThirdsRect
    }
}
