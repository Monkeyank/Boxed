//
//  CenterThird.swift
//  Boxed
//
//  Created by Ankith on 7/2/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class CenterThirdCalculation: WindowCalculation {
    
    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        return isLandscape(visibleFrameOfScreen)
            ? RectResult(centeredVerticalThird(visibleFrameOfScreen), subAction: .centerVerticalThird)
            : RectResult(centeredHorizontal(visibleFrameOfScreen), subAction: .centerHorizontalThird)
    }
    
    private func centeredVerticalThird(_ visibleFrameOfScreen: CGRect) -> CGRect {
        var centerThirdRect = visibleFrameOfScreen
        centerThirdRect.origin.x = visibleFrameOfScreen.minX + floor(visibleFrameOfScreen.width / 3.0)
        centerThirdRect.origin.y = visibleFrameOfScreen.minY
        centerThirdRect.size.width = visibleFrameOfScreen.width / 3.0
        centerThirdRect.size.height = visibleFrameOfScreen.height
        return centerThirdRect
    }
    
    private func centeredHorizontal(_ visibleFrameOfScreen: CGRect) -> CGRect {
        var centerThirdRect = visibleFrameOfScreen
        centerThirdRect.origin.x = visibleFrameOfScreen.minX
        centerThirdRect.origin.y = visibleFrameOfScreen.minY + floor(visibleFrameOfScreen.height / 3.0)
        centerThirdRect.size.width = visibleFrameOfScreen.width
        centerThirdRect.size.height = visibleFrameOfScreen.height / 3.0
        return centerThirdRect
    }
}
