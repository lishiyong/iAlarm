//
//  NSDate+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+YC.h"

@implementation NSDate (YC)

- (NSString *)stringOfTimeShortStyle{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:kCFDateFormatterNoStyle];
    [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:self];
}

@end
