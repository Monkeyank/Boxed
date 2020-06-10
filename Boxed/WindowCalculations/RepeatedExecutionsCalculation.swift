//
//  RepeatedExecutionsCalculation.swift
//  Boxed
//
//  Created by Ankith on 6/8/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

protocol RepeatedExecutionsCalculation {
    func calculateFirstRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult
    
    func calculateSecondRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult

    func calculateThirdRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult
}

extension RepeatedExecutionsCalculation {
    func calculateRepeatedRect(_ window: Window, lastAction: BoxedAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        
        guard let count = lastAction?.count,
            lastAction?.action == action
        else {
            return calculateFirstRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
        }
                
        let position = count % 3
        
        switch (position) {
        case 1:
            return calculateSecondRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
        case 2:
            return calculateThirdRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
        default:
            return calculateFirstRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
        }
        
    }
}
