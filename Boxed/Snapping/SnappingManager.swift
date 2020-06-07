//
//  SnappingManager.swift
//  Boxed
//
//  Created by Ankith on 6/6/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class SnappingManager {
    
    var eventMonitor: EventMonitor?
    var frontmostWindow: AccessibilityElement?
    var frontmostWindowId: Int?
    var windowMoving: Bool? = false;
}
