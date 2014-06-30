//
//  UIDirectManipulationExtension.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/28/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit

extension UIView {
    // NOTE: because of the implementation, each separate gesture recognizer fires separately,
    // and different attributes cannot be manipulated at the same time. This might enable the user
    // to be more precise, because they're only manipulating one degree of freedom at a time, 
    // but if I want to enable multiple degrees of freedom:
    // - set action of all gesture recognizers to the same (e.g. "manipulate")
    // - switch/case in the manipulate function based respondsToSelector, e.g:
    //     case sender.respondsToSelector(Selector("rotation")) => apply rotation transform
    // 
    // - IDEA: enable users to activate different degrees of freedom in editor palette
    func activate() {
        // add gesture recognizers, set user interaction enabled
        // pan gestures
        let lpgr = UILongPressGestureRecognizer(target: self, action: Selector("pan:"))
        lpgr.minimumPressDuration = 0.1
        self.addGestureRecognizer(lpgr)
        
        // pinch gestures
        let pgr = UIPinchGestureRecognizer(target: self, action: Selector("pinch:"))
        self.addGestureRecognizer(pgr)

        // rotation gestures
        let rgr = UIRotationGestureRecognizer(target: self, action: Selector("rotate:"))
        self.addGestureRecognizer(rgr)
        
        self.userInteractionEnabled = true
    }
    
    func pan(sender: UIPanGestureRecognizer){
        switch(sender.state) {
        case .Began:
            UIView.animateWithDuration(0.3) {
                self.alpha = 0.8
                let locationOnScreen = sender.locationInView(self.superview)
                self.center = CGPointMake(locationOnScreen.x, locationOnScreen.y)
            }
        case .Changed:
            let locationOnScreen = sender.locationInView(self.superview)
            self.center = CGPointMake(locationOnScreen.x, locationOnScreen.y)
        case _:
            UIView.animateWithDuration(0.3) {
                self.alpha = 1.0
            }
        }
    }
    
    func pinch(sender: UIPinchGestureRecognizer) {
        self.transform = CGAffineTransformScale(self.transform, sender.scale, sender.scale)
        sender.scale = CGFloat(1.0)
    }

    func rotate(sender: UIRotationGestureRecognizer) {
        self.transform = CGAffineTransformRotate(self.transform, sender.rotation)
        sender.rotation = CGFloat(0.0)
    }
}
