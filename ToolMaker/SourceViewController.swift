//
//  SourceViewController.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/24/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit
import JavaScriptCore

extension JSContextRunner {
    subscript(key: AnyObject) -> AnyObject {
        get {
            return self.getJSValueForKey(key)
        }
        set(newValue) {
           self.setJSValue(newValue, forKey: key)
        }
    }
}

class SourceViewController: UIViewController {
    @IBOutlet var sourceText: UITextView
    @IBOutlet var console: UITextView
    let contextStore : JSContextRunner = JSContextRunner()
//    let context : JSContext = JSContext()  // TODO: instantiate this lazily
    var connection : UIConnection?
    
    func evaluateSource(source: String) -> JSValue {
        
        return contextStore.context.evaluateScript(source)
    }
    
    @IBAction func runButtonPressed(sender: UIButton) {
        console.text = console.text + "\n" + (evaluateSource(sourceText.text).description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contextStore["connection"] = connection!
        contextStore["toView"] = connection!.toView
        
        self.sourceText.text = "thatfunction();"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
