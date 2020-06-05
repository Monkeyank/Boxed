//
//  MessageView.swift
//  Boxed
//
//  Created by Ankith on 6/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class MessagePopover {
    
    var popover: NSPopover
    
    // From func MessageView (underneath)
    var messageView: MessageView
    
    init() {
        popover = NSPopover()
        messageView = MessageView()
        popover.behavior = .transient
        popover.contentViewController = messageView
        
    }
}

class MessageView: NSViewController {
    
    var message: String?
    
    @IBOutlet weak var messageField: NSTextField!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let message = message {
            self.messageField?.stringValue = message
        }
    }
}
