//
//  QuantizedWindowMover.swift
//  Boxed
//
//  Created by Ankith on 6/7/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class QuantizedWindowMover: WindowMover {
    func moveWindowRect(_ windowRect: CGRect, frameOfScreen: CGRect, visibleFrameOfScreen: CGRect, frontmostWindowElement: AccessibilityElement?, action: WindowAction?) {
        guard var movedWindowRect: CGRect = frontmostWindowElement?.rectOfElement() else { return
        }
    }
    
    
}
