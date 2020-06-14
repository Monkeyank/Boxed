//
//  ChangeSizeCalculation.swift
//  Boxed
//
//  Created by Ankith on 6/13/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class ChangeSizeCalculation: WindowCalculation {
    
    let minimumWindowHeight: CGFloat
    let minimumWindowWidth: CGFloat
    let screenEdgeGapSize: CGFloat
    let sizeOffsetAbs: CGFloat
    let curtainChangeSize = Defaults.curtainChangeSize.enabled != false
    
    override init () {
        let defaultHeight = Defaults.minimumWindowHeight.value
        minimumWindowHeight = (defaultHeight <= 0 || defaultHeight > 1)
            ? 0.25
            : CGFloat(defaultHeight)
        
        let defaultWidth = Defaults.minimumWindowWidth.value
        minimumWindowWidth = (defaultWidth <= 0 || defaultWidth > 1)
            ? 0.25
            : CGFloat(defaultHeight)
        
        let windowGapSize = Defaults.gapSize.value
        screenEdgeGapSize = (windowGapSize <= 0) ? 5.0 : CGFloat(windowGapSize)
        
        let defaultSizeOffset = Defaults.sizeOffset.value
        sizeOffsetAbs = (defaultSizeOffset <= 0)
            ? 30.0
            : CGFloat(defaultSizeOffset)
    }
}
