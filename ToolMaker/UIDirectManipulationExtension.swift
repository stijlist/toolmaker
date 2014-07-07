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
    // OR:
    // - implement UIGestureRecognizerDelegate shouldRecognizeSimultaneouslyWithGestureRecognizer in this extension
    // - IDEA: enable users to activate different degrees of freedom in editor palette
    
    
    func pan(gestureRecognizer: UIPanGestureRecognizer) {
        switch(gestureRecognizer.state) {
        case .Began:
            UIView.animateWithDuration(0.3) {
                self.alpha = 0.8
            }
        case .Changed:
            let delta = gestureRecognizer.translationInView(self.superview)
            // if we redraw on every gestureRecognizer callback, then the object flickers because it's
            // redrawing too often, so only change the view's center (triggering a redraw) if the deltas
            // are above some magic number
            // TODO: figure out if this is the best way to avoid flickering
            if abs(delta.x) + abs(delta.y) > 4.0 {
                self.center = CGPointMake(self.center.x + delta.x, self.center.y + delta.y)
                // reset the translation to zero so we only get the delta since the last callback
                gestureRecognizer.setTranslation(CGPointZero, inView: self.superview)
            }
        case _:
            let delta = gestureRecognizer.translationInView(self.superview)
            self.center = CGPointMake(self.center.x + delta.x, self.center.y + delta.y)
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
