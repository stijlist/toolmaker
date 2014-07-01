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
    
    let attributeNames = ["UIView", "UILabel"]
    var GestureRecognizerDictionary : Dictionary<UIGestureRecognizer, UIView> = [:]
    let createdViews : Array<UIView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(ThreeFingerPinchGestureRecognizer(target: self, action: Selector("activateViews:")))
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
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return attributeNames.count
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
        case _:
            let locationInTableView = sender.locationInView(editorPaletteTableView)
            if CGRectContainsPoint(sender.view.frame, locationInTableView) {
                // if the user returns the instantiatedView to the cell from which it came
                GestureRecognizerDictionary[sender]!.removeFromSuperview()
            } else {
                GestureRecognizerDictionary[sender]!.activate()
            }
            GestureRecognizerDictionary.removeValueForKey(sender)
        }
    }
    
    func activateViews(gestureRecognizer: ThreeFingerPinchGestureRecognizer) {
        if(gestureRecognizer.state == .Ended) {
            NSLog("Victory!")
            createdViews.map { $0.activate() }
        }
    }
    
    
    func instantiateViewAtPoint(viewType: String, locationOnScreen: CGPoint, gestureRecognizer: UIGestureRecognizer) {
        // TODO: I can actually instantiate UIViews from an array of their types
        let instantiatedView = DynamicViewInstantiator.instantiateViewFromClass(NSClassFromString(viewType)) as UIView
        instantiatedView.backgroundColor = UIColor.blackColor()
        instantiatedView.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 88.0, 88.0)
        self.view.addSubview(instantiatedView)
        GestureRecognizerDictionary.updateValue(instantiatedView, forKey: gestureRecognizer)
    }
    
}

