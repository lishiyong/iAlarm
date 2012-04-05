//
//  IAAlarmNotify.m
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAAlarm.h"
#import "IAAlarmNotification.h"

@implementation IAAlarmNotification

@synthesize alarm, timeStamp, viewed;

- (id)initWithAlarm:(IAAlarm*)theAlarm{
    self = [super init];
    if (self) {
        alarm = [theAlarm retain];
        timeStamp = [[NSDate date] retain];
        viewed = NO;
    }
    return self;
}

- (void)dealloc{
    [alarm release];
    [timeStamp release];
    [super dealloc];
}


@end
