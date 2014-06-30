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
    let editableAttributes = ["attr1": "hello?", "attr2":"world."]
    let attributeOrder = ["attr1", "attr2"]
    let attributeItems = ["UIView", "UILabel"]
    var GRDictionary : Dictionary<UIGestureRecognizer, UIView> = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("PaletteItem") as UITableViewCell
        let label = UILabel(frame: cell.bounds)
        label.text = editableAttributes[attributeOrder[indexPath.row]]
        cell.addSubview(label)
        let gr = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(gr)
        
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return attributeOrder.count
    }

    func handlePan(sender: UIPanGestureRecognizer) {

        let startingCell = sender.view as UITableViewCell
        let locationOnScreen = sender.locationInView(self.view)
        let viewType = attributeItems[startingCell.tag]
        sender.cancelsTouchesInView = true
        
        switch(sender.state) {
        case .Began:
            let instantiatedView : UIView! = DynamicViewInstantiator.instantiateViewFromClass(NSClassFromString(viewType)) as UIView
            instantiatedView.backgroundColor = UIColor.blackColor()
            instantiatedView.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 88.0, 88.0) // hack
            self.view.addSubview(instantiatedView)
            GRDictionary.updateValue(instantiatedView, forKey: sender)
        case .Changed:
            let instantiatedView = GRDictionary[sender]!
            instantiatedView.frame = CGRectMake(locationOnScreen.x - 44, locationOnScreen.y - 44, 88.0, 88.0) // hack
        case _:
            let locationInTableView = sender.locationInView(editorPaletteTableView)
            if CGRectContainsPoint(sender.view.frame, locationInTableView) {
                // if the user returns the instantiatedView to the cell from which it came
                GRDictionary[sender]!.removeFromSuperview()
            } else {
                GRDictionary[sender]!.activate()
            }
            GRDictionary.removeValueForKey(sender)
        }
    }
}

