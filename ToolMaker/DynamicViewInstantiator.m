//
//  DynamicViewInstatiator.m
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/26/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

//#import <objc/runtime.h>
#import "DynamicViewInstantiator.h"

@implementation DynamicViewInstantiator : NSObject
+ (id)instantiateViewFromClass:(Class) klass {
    return [[klass alloc] init];
}
@end
