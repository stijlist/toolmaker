//
//  JSContext.m
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/10/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

@import JavaScriptCore;
#import "JSContextRunner.h"
#import "objc/runtime.h"

@interface JSContextRunner ()
@end



@implementation JSContextRunner : NSObject
- (id) init {
    if (self = [super init]) {
        _context = [[JSContext alloc] init];
    }
    
    // TODO: test sending messages to objects from javascript
//    _testMethod = __weak ^msgSendInvocation {
//        objc_msgsend([target cString], [action cString], args);
//        return (NSString *)self.context[lookup];
//    }
//    
//    _context[@"thatfunction"] = _testMethod;
   // returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};

    return self;
}
- (void) setJSValue:(id)value forKey:(id)key {
    self.context[key] = value;
}
- (id) getJSValueForKey:(id)key {
    return self.context[key];
}
- (void) printKeys {
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList([self.context class], &numberOfProperties);
        
        for (NSUInteger i = 0; i < numberOfProperties; i++)
        {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
            NSLog(@"Property %@ attributes: %@", name, attributesString);
        }
        free(propertyArray);
    }
}
@end
