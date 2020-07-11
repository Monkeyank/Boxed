//
//  MovveDownCalculation.swift
//  Boxed
//
//  Created by Ankith on 7/2/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class MoveDownCalculation: WindowCalculation {
    
    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        var calculatedWindowRect = window.rect
        calculatedWindowRect.origin.y = visibleFrameOfScreen.minY
        
        if window.rect.width >= visibleFrameOfScreen.width {
            calculatedWindowRect.size.width = visibleFrameOfScreen.width
            calculatedWindowRect.origin.x = visibleFrameOfScreen.minX
        } else if Defaults.centeredDirectionalMove.enabled != false {
            calculatedWindowRect.origin.x = round((visibleFrameOfScreen.width - window.rect.width) / 2.0) + visibleFrameOfScreen.minX
        }
        return RectResult(calculatedWindowRect)
    }
}
