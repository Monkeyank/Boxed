//
//  CenteringFixedWindowMover.swift
//  Boxed
//
//  Created by Ankith on 6/7/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

/**
 If the window is fixed size, center it in the proposed window area
 */

import Foundation

class CenteringFixedSizeWindowMover: WindowMover {
    
    func moveWindowRect(_ windowRect: CGRect, frameOfScreen: CGRect, visibleFrameOfScreen: CGRect, frontmostWindowElement: AccessibilityElement?, action: WindowAction?) {
        guard let currentWindowRect: CGRect = frontmostWindowElement?.rectOfElement() else { return
        }
        
        var adjustedWindowRect: CGRect = currentWindowRect
    }
}
