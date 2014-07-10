//
//  UIConnection.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/10/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit
import JavaScriptCore

class UIConnection: NSObject, JSExport {
    let fromView : UIView
    let toView : UIView
    init(fromView: UIView, toView: UIView) {
        self.fromView = fromView
        self.toView = toView
    }
    
    
}
