//
//  DAG.swift
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/16/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

import Foundation

// Eventually, a directed acyclic graph of UIConnections
// we want to be able to call .map on this
@objc protocol Directed {
    var to: AnyObject? { get }
}
struct DAG<T:Directed> {
    var roots: [T]
    // figure out how to do map correctly
//    func map(closure: (T) -> T) {
//        roots.map {
//            nval = closure(root)
//            nval.to = closure(root.to) // apply function
//        }
//    }
}