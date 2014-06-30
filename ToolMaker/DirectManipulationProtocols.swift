//
//  GrowableProtocol.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/29/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import UIKit

protocol Growable {
    func grow(scale: Double) -> ()
}

protocol Shrinkable {
    
}

protocol AttributeEditable {
    var attributes : Dictionary<String, AnyObject> { get }
    
    
}
