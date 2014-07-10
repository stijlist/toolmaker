//
//  JSContext.h
//  ToolMaker
//
//  Created by Bert Muthalaly on 7/10/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

@import JavaScriptCore;
#import <Foundation/Foundation.h>


@interface JSContextRunner : NSObject
@property JSContext* context;
- (void) setJSValue:(id)value forKey:(id)key;
- (id) getJSValueForKey:(id)key;

@end
