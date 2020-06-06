//
//  WindowManager.swift
//  Boxed
//
//  Created by Ankith on 6/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class WindowManager {
    
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