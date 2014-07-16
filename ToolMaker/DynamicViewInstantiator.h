//
//  DynamicViewInstatiator.h
//  ToolMaker
//
//  Created by Bert Muthalaly on 6/26/14.
//  Copyright (c) 2014 Bert Muthalaly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicViewInstantiator : NSObject
+ (id)instantiateViewFromClass:(Class)className;
@end
