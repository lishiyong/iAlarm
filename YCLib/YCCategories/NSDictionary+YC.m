//
//  NSDictionary+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+YC.h"

@implementation NSDictionary (YC)

- (NSString *)description{
    NSMutableString *string = [NSMutableString stringWithCapacity:100];
    [string appendString:@"\n{"];
    for (id key in [self allKeys]) {
        [string appendString:@"\n"];
        [string appendString:@"  "];
        [string appendFormat:@"%@",[key description]];
        [string appendString:@" = "];
        [string appendFormat:@"%@",[[self objectForKey:key] description]];
    }
    [string appendString:@"\n}"];
    return string;
}

@end
