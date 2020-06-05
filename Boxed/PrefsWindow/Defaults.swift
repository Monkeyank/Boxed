//
//  Defaults.swift
//  Boxed
//
//  Created by Ankith on 6/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class Defaults {
    
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


