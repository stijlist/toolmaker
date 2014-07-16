//
//  UIConnection.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/10/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

// TODO: revise for clarity
// A *connection* is a one-way channel connecting two UIViews
// and an optional function that operates on the state
// of the first component and returns a signal that the second
// UIView can "understand"


import UIKit
import JavaScriptCore

class Touch {
    var origin : CGPoint = CGPointZero
    var location : CGPoint = CGPointZero
    var translation : CGPoint = CGPointZero
    var duration : CGFloat = 0.0
}

class ComponentState {
    let touches : [Touch]?
    let attributes : [String:AnyObject]
    
    init(touches: [Touch]?, attributes: [String:AnyObject]) {
        if touches { self.touches = touches! }
        self.attributes = attributes
    }
}

class Connection: NSObject, JSExport {
    let fromView : UIView
    let toView : UIView
    // this transformation function needs to be capable of taking a JS function
    // in the JS editor, set the variable "transformation" on the global object
    // e.g. var transformation = function(componentState) {
    //           // access componentState.{touches,attributes} in here
    //           // return a JSON object representing the signal to send to the
    //           // receiving component
    //      }
    // in the event loop (objc-side) we'll run:
    // [context[@"transformation"] callWithArguments:@[componentState]];
    // and return the JSON object the user returns
    // TODO: think more carefully about the return value of this function:
    // Do we want it to be void, and have it actually set properties on the
    // views it's concerned with?
    var transformationFn : ((ComponentState) -> NSDictionary)?

    init(fromView: UIView, toView: UIView) {
        self.fromView = fromView
        self.toView = toView
    }
}
