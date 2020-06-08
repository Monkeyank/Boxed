//
//  WindowCalculations.swift
//  Boxed
//
//  Created by Ankith on 6/8/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

protocol Calculation {
    
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
    let resultingAction: WindowAction
    let resultingSubAction: SubWindowAction?
    
    init(rect: CGRect, screen: NSScreen, resultingAction: WindowAction, resultingSubAction: SubWindowAction? = nil) {
        self.rect = rect
        self.resultingAction = resultingAction
        self.resultingSubAction = resultingSubAction
    }

}
