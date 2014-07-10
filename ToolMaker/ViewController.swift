//
//  ViewController.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/24/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UIGestureRecognizerDelegate, CreatedViewManager {
    
    @IBOutlet var editorPaletteTableView: UITableView
    
    var editorPaletteActivated = true // collapse into an editorState enum variable later
    let attributeNames = ["UIView", "UILabel", "UIButton", "UITextField"]
    var createdViews : Array<UIView> = []
    var activeGestureRecognizersForView : Dictionary<UIView, NSSet> = [:] // Arrays as values causes null pointer exception
    func activateDirectManipulation(viewToManipulate: UIView) {
        // pan gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: viewToManipulate, action: Selector("pan:"))
        viewToManipulate.addGestureRecognizer(panGestureRecognizer)
        
        // pinch gestures
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: viewToManipulate, action: Selector("pinch:"))
        viewToManipulate.addGestureRecognizer(pinchGestureRecognizer)
        
        // rotation gestures
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: viewToManipulate, action: Selector("rotate:"))
        viewToManipulate.addGestureRecognizer(rotationGestureRecognizer)
        
        panGestureRecognizer.delegate = self
        pinchGestureRecognizer.delegate = self
        rotationGestureRecognizer.delegate = self
        // defensive; in case the UIView's parent has set userInteractionEnabled to false
        viewToManipulate.userInteractionEnabled = true
        let recognizerSet = NSMutableSet(array: [panGestureRecognizer, pinchGestureRecognizer, rotationGestureRecognizer])
        activeGestureRecognizersForView[viewToManipulate] = recognizerSet
        
    }
    
    func deactivateDirectManipulation(viewToManipulate: UIView) {
        let gestureRecognizerSet = activeGestureRecognizersForView[viewToManipulate]!
        for recognizer in gestureRecognizerSet { viewToManipulate.removeGestureRecognizer(recognizer as UIGestureRecognizer) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: Selector("activateViews:")))
        (self.view as EditorCanvas).delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let paletteItem = tableView.dequeueReusableCellWithIdentifier("PaletteItem") as UITableViewCell
        // configure label
        let label = UILabel(frame: paletteItem.bounds)
        label.text = attributeNames[indexPath.row]
        paletteItem.addSubview(label)
        // configure gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapInEditorPaletteCell:"))
        paletteItem.addGestureRecognizer(gestureRecognizer)

        // add tag so we can reference the indexPath from inside any gestureRecognizer callbacks
        paletteItem.tag = indexPath.row
        return paletteItem
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int { return attributeNames.count }
    
    // a lot of this logic should probably be in some kind of editor palette object
    func activateViews(gestureRecognizer: UIPinchGestureRecognizer) {
        enum palettePosition { case Onscreen, Offscreen }
        func animateEditorPalette(position: palettePosition) {
            var (currentX, currentY) = (editorPaletteTableView.center.x, editorPaletteTableView.center.y)
            let editorWidth = editorPaletteTableView.bounds.width
            switch position {
            case .Onscreen:
                currentX -= editorWidth
            case .Offscreen:
                currentX += editorWidth
            }
            UIView.animateWithDuration(0.2) {
                self.editorPaletteTableView.center = CGPointMake(currentX, currentY)
            }
        }
        func activateEditor() {
            if !self.editorPaletteActivated {
                animateEditorPalette(.Onscreen)
                for view in createdViews { self.activateDirectManipulation(view) } // .map crashes Xcode
                self.editorPaletteActivated = true
            }
        }
        func deactivateEditor() {
            if self.editorPaletteActivated {
                animateEditorPalette(.Offscreen)
                for view in createdViews { self.deactivateDirectManipulation(view) } // .map crashes Xcode
                self.editorPaletteActivated = false
            }
        }
        if(gestureRecognizer.state == .Ended && gestureRecognizer.scale > 1.0) {
            activateEditor()
        } else if(gestureRecognizer.state == .Ended && gestureRecognizer.scale < 1.0) {
            deactivateEditor()
        }
    }

    func handleTapInEditorPaletteCell(sender: UITapGestureRecognizer) {
        let startingCell = sender.view as UITableViewCell
        let locationOnScreen = sender.locationInView(self.view)
        // look up view type based on cell's index (read from the cell's tag)
        let viewType = attributeNames[startingCell.tag]
        
        if sender.state == .Ended { instantiateViewAtPoint(viewType, locationOnScreen: locationOnScreen) }
    }
    
    func instantiateViewAtPoint(viewType: String, locationOnScreen: CGPoint) {
        // TODO: I can actually instantiate UIViews from an array of their types once the Swift compiler stops erroring
        // e.g. let viewTypes = [UIView.self, UILabel.self]
        // calling with let viewType = viewTypes[0]; instantiatedView = viewType()
        let instantiatedView = DynamicViewInstantiator.instantiateViewFromClass(NSClassFromString(viewType)) as UIView
        switch instantiatedView {
        case let label as UILabel:
            label.text = "Hello!"
            label.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 88.0, 88.0)
        case let button as UIButton:
            button.setTitle("Button", forState: .Normal)
            button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 66.0, 44.0)
        case let textField as UITextField:
            textField.text = "Lorem ipsum doler sit amet"
            textField.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 236.0, 88.0)
        case let genericView:
            genericView.backgroundColor = UIColor.grayColor()
            genericView.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 88.0, 88.0)
        }
        
        self.view.addSubview(instantiatedView)
        createdViews += instantiatedView
        self.activateDirectManipulation(instantiatedView)
    }
    
    func handleHoverStateBeganForSubview(subview: UIView) {
        NSLog("Hover state began")
        if let topMostView = topmostViewContainingView(subview) {
        }
    }
    func handleHoverStateEndedForSubview(subview: UIView) {
        NSLog("Hover state ended")
        if let topmost = topmostViewContainingView(subview) {
            topmost.addSubview(subview)
            subview.frame = CGRectMake(subview.frame.origin.x - topmost.frame.origin.x, subview.frame.origin.y - topmost.frame.origin.y, subview.frame.size.width, subview.frame.size.height)
        }
    }
    
    func topmostViewContainingView(v: UIView) -> UIView? {
        let collidingViews = createdViews.filter { createdView in
            return CGRectContainsRect(createdView.frame, v.frame) && !(createdView.isEqual(v))
        }
        if collidingViews.count > 0 {
            NSLog("we're in the right case")
            return collidingViews[collidingViews.count - 1]
        } else {
            return nil
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!,
        shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
            // This conditional is suboptimal partially because swift compiler support for casing on multiple optionals
            // is incomplete
            let delegatePair = (gestureRecognizer?.delegate, otherGestureRecognizer?.delegate)
            switch delegatePair {
            case let(.Some(d1), .Some(d2)):
                return d1.isEqual(self) && d1.isEqual(self)
            case _:
                return false
            }
    }
}