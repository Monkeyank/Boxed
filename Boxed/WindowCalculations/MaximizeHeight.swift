//
//  MaximizeHeight.swift
//  Boxed
//
//  Created by Ankith on 6/13/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class MaximizeHeightCalculation: WindowCalculation {
    
    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        var maxHeightRect = window.rect
        maxHeightRect.origin.y = visibleFrameOfScreen.minY
        maxHeightRect.size.height = visibleFrameOfScreen.height
        return RectResult(maxHeightRect)
    }
    
}
