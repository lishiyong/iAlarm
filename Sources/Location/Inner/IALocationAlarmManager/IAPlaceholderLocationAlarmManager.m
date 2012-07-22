//
//  IAPlaceholderLocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IABasicLocationAlarmManager.h"
#import "IAPlaceholderLocationAlarmManager.h"

@implementation IAPlaceholderLocationAlarmManager


- (id)initWithDelegate:(id)delegate{
    //这里不能用实例变量，因为下面就要重新为子类分配内存。
    
    id obj = nil;
    obj = [[IABasicLocationAlarmManager alloc] initWithDelegate:delegate];
    return obj;
}

static IAPlaceholderLocationAlarmManager *single = nil;
+ (id)allocWithZone:(NSZone *)zone
{
    if (single == nil) {
        single = NSAllocateObject([self class], 0, zone);
    }
    return single;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


@end
