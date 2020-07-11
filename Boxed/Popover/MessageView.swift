//
//  MessageView.swift
//  Boxed
//
//  Created by Ankith on 6/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

class MessagePopover {
    var messageView: MessageView
    var popover: NSPopover
    
    init() {
        popover = NSPopover()
        messageView = MessageView()
        popover.behavior = .transient
        popover.contentViewController = messageView
    }
    
    public func show(message: String, sender: NSView) {
        let positioningView = sender
        let positioningRect = NSZeroRect
        let preferredEdge: NSRectEdge = .maxX
        messageView.message = message

        popover.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
}

class MessageView: NSViewController {
    
    @IBOutlet weak var messageField: NSTextField!
    
    var message: String?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let message = message {
            self.messageField?.stringValue = message
        }
    }
}
