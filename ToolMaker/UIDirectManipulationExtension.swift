//
//  UIDirectManipulationExtension.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/28/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit


extension UIView {
        
    func pan(gestureRecognizer: UIPanGestureRecognizer) {
        let (vx, vy) = (gestureRecognizer.velocityInView(self.superview).x, gestureRecognizer.velocityInView(self.superview).y)
        switch(gestureRecognizer.state) {
        case .Began:
            UIView.animateWithDuration(0.3) {
                self.alpha = 0.8
            }
        case .Changed:
            let delta = gestureRecognizer.translationInView(self.superview)
            self.center = CGPointMake(self.center.x + delta.x, self.center.y + delta.y)
            gestureRecognizer.setTranslation(CGPointZero, inView: self.superview)
            // TODO: handle hover state began
        case _:
            let delta = gestureRecognizer.translationInView(self.superview)
            self.center = CGPointMake(self.center.x + delta.x, self.center.y + delta.y)
            if let manager = self.superview as? CreatedViewManager {
                manager.handleHoverStateEndedForSubview(self)
            }

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
