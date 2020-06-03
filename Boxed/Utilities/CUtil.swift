//
//  CUtil.swift
//  Boxed
//
//  Created by Ankith on 6/3/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class CUtil {
    
    // Both funcs bridge objects into a pointer in order to pass into a C function
    
    static func bridge<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer {
        return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
    }
    
    static func bridge<T : AnyObject>(ptr: UnsafeMutableRawPointer) -> T {
        return UnsafeMutableRawPointer(ptr).takeUnretainedValue()
    }
}

