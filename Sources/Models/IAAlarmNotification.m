//
//  IAAlarmNotify.m
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCGFunctions.h"
#import "IAAlarm.h"
#import "IAAlarmNotification.h"


#define    knotificationIdInIAAlarmNotification     @"knotificationIdInIAAlarmNotification"
#define    kalarmInIAAlarmNotification              @"kalarmInIAAlarmNotification"
#define    ktimeStampInIAAlarmNotification          @"ktimeStampInIAAlarmNotification"
#define    kviewedInIAAlarmNotification             @"kviewedInIAAlarmNotification"

@implementation IAAlarmNotification

@synthesize notificationId, alarm, timeStamp, viewed;


- (id)initWithAlarm:(IAAlarm*)theAlarm{
    self = [super init];
    if (self) {
        notificationId = [[NSString stringWithFormat:@"%@-%@",theAlarm.alarmId,YCSerialCode()] copy];
        alarm = [theAlarm retain];
        timeStamp = [[NSDate date] retain];
        viewed = NO;
    }
    return self;
}

- (void)dealloc{
    [notificationId release];
    [alarm release];
    [timeStamp release];
    [super dealloc];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:notificationId forKey:knotificationIdInIAAlarmNotification];
	[encoder encodeObject:alarm forKey:kalarmInIAAlarmNotification];
	[encoder encodeObject:timeStamp forKey:ktimeStampInIAAlarmNotification];
	[encoder encodeBool:viewed forKey:kviewedInIAAlarmNotification];
}

- (id)initWithCoder:(NSCoder *)decoder {
	
    self = [super init];
    if (self) {	
        notificationId = [[decoder decodeObjectForKey:knotificationIdInIAAlarmNotification] retain];
		alarm = [[decoder decodeObjectForKey:kalarmInIAAlarmNotification] retain];
		timeStamp = [[decoder decodeObjectForKey:ktimeStampInIAAlarmNotification] retain];
		viewed =[decoder decodeBoolForKey:kviewedInIAAlarmNotification];
    }
    return self;
}

@end
