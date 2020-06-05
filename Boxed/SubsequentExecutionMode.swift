//
//  SubsequentExecutionMode.swift
//  Boxed
//
//  Created by Ankith on 6/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

enum SubsequentExecutionMode: Int {
    case resize = 0
    case acrossMonitor = 1
    case none = 2
    case acrossAndResize = 3
}

class SubsequentExecutionDefault {
    private let key: String = "subsequentExecutionMode"
    private var initialized = false
    
    var value: SubsequentExecutionMode {
        didSet {
            if initialized {
                UserDefaults.standard.set(value.rawValue, forKey: key)
            }
        }
    }
    
    init() {
        let intValue = UserDefaults.standard.integer(forKey: key)
        value = SubsequentExecutionMode(rawValue: intValue) ?? .resize
        initialized = true
    }
    
    var resizes: Bool {
        switch value {
        case .resize, .acrossAndResize: return true
        default: return false
        }
    }

    var traversesDisplays: Bool {
        switch value {
        case .acrossMonitor, .acrossAndResize: return true
        default: return false
        }
    }
}
