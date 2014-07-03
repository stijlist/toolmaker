//
//  ViewController.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/24/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var editorPaletteTableView: UITableView
    var editorPaletteActivated = true
    let attributeNames = ["UIView", "UILabel", "UIButton", "UITextField"]
    var GestureRecognizerDictionary : Dictionary<UIGestureRecognizer, UIView> = [:]
    var createdViews : Array<UIView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: Selector("activateViews:")))
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
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFromEditorPalette:"))
        paletteItem.addGestureRecognizer(gestureRecognizer)
        // add tag so we can reference the indexPath from inside any gestureRecognizer callbacks
        paletteItem.tag = indexPath.row
        return paletteItem
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int { return attributeNames.count }
    
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
                for view in createdViews { view.userInteractionEnabled = true } // .map crashes Xcode
                self.editorPaletteActivated = true
            }
        }
        func deactivateEditor() {
            if self.editorPaletteActivated {
                animateEditorPalette(.Offscreen)
                for view in createdViews { view.userInteractionEnabled = false } // .map crashes Xcode
                self.editorPaletteActivated = false
            }
        }
        if(gestureRecognizer.state == .Ended && gestureRecognizer.scale > 1.0) {
            activateEditor()
        } else if(gestureRecognizer.state == .Ended && gestureRecognizer.scale < 1.0) {
            deactivateEditor()
        }
    }

    func handlePanFromEditorPalette(sender: UIPanGestureRecognizer) {

        let startingCell = sender.view as UITableViewCell
        let locationOnScreen = sender.locationInView(self.view)
        // look up view type based on cell's index (read from the cell's tag)
        let viewType = attributeNames[startingCell.tag]
        
        switch(sender.state) {
        case .Began:
            instantiateViewAtPoint(viewType, locationOnScreen: locationOnScreen, gestureRecognizer: sender)
        case .Changed:
            let instantiatedView = GestureRecognizerDictionary[sender]!
            instantiatedView.center = CGPointMake(locationOnScreen.x, locationOnScreen.y)
        case .Ended where CGRectContainsPoint(editorPaletteTableView.frame, locationOnScreen):
            GestureRecognizerDictionary[sender]!.removeFromSuperview()
            GestureRecognizerDictionary.removeValueForKey(sender)
        case .Ended:
            GestureRecognizerDictionary[sender]!.activate()
            createdViews += GestureRecognizerDictionary[sender]!
            GestureRecognizerDictionary.removeValueForKey(sender)
        case _:
            GestureRecognizerDictionary[sender]!.removeFromSuperview()
            GestureRecognizerDictionary.removeValueForKey(sender)
        }
    }
    
    func instantiateViewAtPoint(viewType: String, locationOnScreen: CGPoint, gestureRecognizer: UIGestureRecognizer) {
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
            button.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 88.0, 44.0)
        case let textField as UITextField:
            textField.text = "Lorem ipsum doler sit amet"
            textField.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 236.0, 88.0)
        case let genericView:
            genericView.backgroundColor = UIColor.grayColor()
            genericView.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 88.0, 88.0)
        }
        
        self.view.addSubview(instantiatedView)
        GestureRecognizerDictionary.updateValue(instantiatedView, forKey: gestureRecognizer)
    }
    
}

