//
//  Maximize.swift
//  Boxed
//
//  Created by Ankith on 6/13/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class MaximizeCalculation: WindowCalculation {

    override func calculateRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        return RectResult(visibleFrameOfScreen)
    }
    
}
