//
//  EditorCanvas.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/10/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit

@objc protocol CreatedViewManager {
    func handleHoverStateBeganForSubview(subview: UIView)
    func handleHoverStateEndedForSubview(subview: UIView)
//    func displaySnappableObjectsForSubview(view: UIView)
}


class EditorCanvas: UIView, CreatedViewManager {
    // this should really be non-optional, but I don't know how to handle
    // initializing it before super.init
    weak var delegate : CreatedViewManager?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func handleHoverStateBeganForSubview(subview: UIView) {
        delegate?.handleHoverStateBeganForSubview(subview)
    }
    func handleHoverStateEndedForSubview(subview: UIView) {
        delegate?.handleHoverStateEndedForSubview(subview)
    }
}
