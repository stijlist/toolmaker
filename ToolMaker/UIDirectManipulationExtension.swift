//
//  UIDirectManipulationExtension.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/28/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit

extension UIView : Growable, Shrinkable {
    func activate(){
        // add gesture recognizers, set user interaction enabled
        let lpgr = UILongPressGestureRecognizer(target: self, action: Selector("pan:"))
        lpgr.minimumPressDuration = 0.1
        let pgr = UIPinchGestureRecognizer(target: self, action: Selector("grow:"))
        self.addGestureRecognizer(lpgr)
        self.userInteractionEnabled = true
    }
    
    func pan(sender: UIPanGestureRecognizer){
        switch(sender.state) {
        case .Began:
            UIView.animateWithDuration(0.3) {
                self.alpha = 0.8
                self.transform = CGAffineTransformMakeScale(1.2, 1.2)
                let locationOnScreen = sender.locationInView(self.superview)
                self.center = CGPointMake(locationOnScreen.x, locationOnScreen.y)
            }
        case .Changed:
            let locationOnScreen = sender.locationInView(self.superview)
            
            self.center = CGPointMake(locationOnScreen.x, locationOnScreen.y)
        case _:
            UIView.animateWithDuration(0.3) {
                self.alpha = 1.0
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
        }
    }
    
    func grow(scale: Double) {
        UIView.animateWithDuration(0.3) {
            self.transform = CGAffineTransformMakeScale(CGFloat(scale), CGFloat(scale))
        }
    }
    
    func shrink(scale: Double) {
        UIView.animateWithDuration(0.3) {
            self.transform = CGAffineTransformMakeScale(CGFloat(scale), CGFloat(scale))
            
        }
    }
}
