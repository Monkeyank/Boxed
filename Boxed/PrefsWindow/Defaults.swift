//
//  Defaults.swift
//  Boxed
//
//  Created by Ankith on 6/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class Defaults {
    
    static let launchOnLogin = BoolDefault(key: "launchOnLogin")
    static let disabledApps = StringDefault(key: "disabledApps")
    static let hideMenuBarIcon = BoolDefault(key: "hideMenubarIcon")
    
    // Found Shortcut alternatives from Magnet Window Resizer defaults
    static let alternateDefaultShortcuts = BoolDefault(key: "alternateDefaultShortcuts")
    static let subsequentExecutionMode = SubsequentExecutionDefault()
    static let allowAnyShortcut = BoolDefault(key: "allowAnyShortcut")
    static let windowSnapping = OptionalBoolDefault(key: "windowSnapping")
    static let almostMaximizeHeight = FloatDefault(key: "almostMaximizeHeight")
    static let almostMaximizeWidth = FloatDefault(key: "almostMaximizeWidth")
    static let gapSize = FloatDefault(key: "gapSize")
    static let snapEdgeMarginTop = FloatDefault(key: "snapEdgeMarginTop", defaultValue: 5)
    static let snapEdgeMarginBottom = FloatDefault(key: "snapEdgeMarginBottom", defaultValue: 5)
    static let snapEdgeMarginLeft = FloatDefault(key: "snapEdgeMarginLeft", defaultValue: 5)
    static let snapEdgeMarginRight = FloatDefault(key: "snapEdgeMarginRight", defaultValue: 5)
    static let centeredDirectionalMove = OptionalBoolDefault(key: "centeredDirectionalMove")
    static let ignoredSnapAreas = IntDefault(key: "ignoredSnapAreas")
    static let traverseSingleScreen = OptionalBoolDefault(key: "traverseSingleScreen")
    static let minimumWindowWidth = FloatDefault(key: "minimumWindowWidth")
    static let minimumWindowHeight = FloatDefault(key: "minimumWindowHeight")
    static let sizeOffset = FloatDefault(key: "sizeOffset")
    static let unsnapRestore = OptionalBoolDefault(key: "unsnapRestore")
    static let curtainChangeSize = OptionalBoolDefault(key: "curtainChangeSize")
    static let relaunchOpensMenu = BoolDefault(key: "relaunchOpensMenu")
    
}

// Function to store Boolean Defaults
class BoolDefault {
    
    private var initialized = false
    private let key: String
    
    var enabled: Bool {
        didSet {
            if initialized {
                UserDefaults.standard.set(enabled, forKey: key)
            }
        }
    }
    
    init(key: String) {
        self.key = key
        enabled = UserDefaults.standard.bool(forKey: key)
        initialized = true
    }
}

// Function to store Optional Boolean Defaults (May be null)
class OptionalBoolDefault {
    
    private let key:String
    private var initialized = false
    var enabled: Bool? {
        didSet {
            if initialized {
                if enabled == true {
                    UserDefaults.standard.set(1, forKey: key)
                } else if enabled == false {
                    UserDefaults.standard.set(2, forKey: key)
                } else {
                    UserDefaults.standard.set(0, forKey: key)
                }
            }
        }
    }
    
    init(key: String) {
        
        self.key = key
        let intValue = UserDefaults.standard.integer(forKey: key)
        switch intValue {
        case 1: enabled = true
        case 2: enabled = false
        default: break
        }
        initialized = true
    }
}

class StringDefault {
    
    private let key: String
    private var initialized = false
    
    var value: String? {
        didSet {
            if initialized {
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }
    
    init(key: String) {
        self.key = key
        value = UserDefaults.standard.string(forKey: key)
        initialized = true
    }
}

class FloatDefault {
    
    private let key: String
    private var initialized = false
    
    var value: Float {
        didSet {
            if initialized {
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }
    
    init(key: String, defaultValue: Float = 0) {
        self.key = key
        value = UserDefaults.standard.float(forKey: key)
        if(defaultValue != 0 && value == 0) {
            value = defaultValue
        }
        initialized = true
    }
}

class IntDefault {
    
    private let key: String
    private var initialized = false
    
    var value: Int {
        didSet {
            if initialized {
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }
    
    init(key: String) {
        self.key = key
        value = UserDefaults.standard.integer(forKey: key)
        initialized = true
    }
}

