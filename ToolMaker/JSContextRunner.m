//
//  JSContext.m
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/10/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

@import JavaScriptCore;
#import "JSContextRunner.h"
#import <objc/runtime.h>

@interface JSContextRunner ()
@property (nonatomic, copy) NSString *(^theTESTMETHOD)(NSString *, NSString *, NSArray *);
@end

@implementation JSContextRunner : NSObject
- (id) init {
    if (self = [super init]) {
        _context = [[JSContext alloc] init];
    }
    _theTESTMETHOD = ^NSString *(NSString *target, NSString *action, NSArray *args) {
        
        objc_msgSend([target cString], [action cString], args)
        return (NSString*)self.context[lookup]; // TODO: fix this retain cycle
    };
    
    _context[@"thatfunction"] = _theTESTMETHOD;
   // returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};

    return self;
}
- (void) setJSValue:(id)value forKey:(id)key {
    self.context[key] = value;
}
- (id) getJSValueForKey:(id)key {
    return self.context[key];
}
@end
