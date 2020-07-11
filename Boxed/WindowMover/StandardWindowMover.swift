//
//  StandardWindowMover.swift
//  Boxed
//
//  Created by Ankith on 6/7/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class StandardWindowMover: WindowMover {
    func moveWindowRect(_ windowRect: CGRect, frameOfScreen: CGRect, visibleFrameOfScreen: CGRect, frontmostWindowElement: AccessibilityElement?, action: WindowAction?) {
        let previousWindowRect: CGRect? = frontmostWindowElement?.rectOfElement()
        if previousWindowRect?.isNull == true {
            return
        }
        frontmostWindowElement?.setRectOf(windowRect)
    }
}
