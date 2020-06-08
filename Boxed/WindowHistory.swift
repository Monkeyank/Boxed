//
//  WindowHistory.swift
//  Boxed
//
//  Created by Ankith on 6/7/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

typealias WindowId = Int

class WindowHistory {
    // The last window frame that the user positioned
    var restoreRects = [WindowId: CGRect]()
    
    // The last window frame that this app positioned
    var lastBoxedActions = [WindowId: BoxedAction]()
}
