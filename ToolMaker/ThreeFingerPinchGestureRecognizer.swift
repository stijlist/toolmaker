//
//  ThreeFingerPinchGestureRecognizer.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/1/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit

class ThreeFingerPinchGestureRecognizer: UIGestureRecognizer {
    override func reset() {
        super.reset()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event:UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        if touches.count == 3 {
            state = .Possible
            lastSpreadValue = spread(touches)
            NSLog("Spread: %f", lastSpreadValue)
        }
    }
    
    var lastSpreadValue = CGFloat(0.0)
    override func touchesMoved(touches: NSSet, withEvent event:UIEvent) {

        super.touchesMoved(touches, withEvent: event)
        let currentSpreadValue = spread(touches)
        NSLog("Spread: %f", currentSpreadValue)

        if touches == 3 && currentSpreadValue < lastSpreadValue {
            state = .Began
        } else {
            state = .Cancelled
        }
        lastSpreadValue = currentSpreadValue
    }
    override func touchesEnded(touches: NSSet, withEvent event:UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        state = .Ended
    }
    override func touchesCancelled(touches: NSSet, withEvent event:UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        state = .Cancelled
    }
    
    
    // private implementation methods
    func spread(touches: NSSet) -> CGFloat {
        var centroidPoint = centroid(touches)
        var averageDistance = CGFloat(0.0)
        for touch : AnyObject in touches {
            let touchLocation = (touch as UITouch).locationInView(self.view)
            let xDistance = CGFloat(touchLocation.x - centroidPoint.x)
            let yDistance = CGFloat(touchLocation.y - centroidPoint.y)
            averageDistance += CGFloat(abs(sqrt(CDouble((xDistance * xDistance) + (yDistance * yDistance)))))
        }
        let retVal = averageDistance / CGFloat(touches.count)
        return retVal
    }
    
    func centroid(touches: NSSet) -> CGPoint {
        var centroidPoint = CGPointZero
        for touch: AnyObject in touches {
            let touchLocation = (touch as UITouch).locationInView(self.view)
            centroidPoint = CGPointMake(touchLocation.x + centroidPoint.x, touchLocation.y + centroidPoint.y)
        }
        centroidPoint.x = centroidPoint.x / CGFloat(touches.count)
        centroidPoint.y = centroidPoint.y / CGFloat(touches.count)
        return centroidPoint
    }
}
