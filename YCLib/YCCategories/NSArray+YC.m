//
//  NSArray+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSArray+YC.h"

@implementation NSArray (YC)

- (NSString *)description{
    NSMutableString *string = [NSMutableString stringWithCapacity:100];
    [string appendString:@"\n("];
    for (id obj in self) {
        [string appendString:@"\n"];
        [string appendString:@"  "];
        [string appendFormat:@"%@",[obj description]];
    }
    [string appendString:@"\n)"];
    return string;
}

@end
