//
//  IAAlarmNotify.m
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCFunctions.h"
#import "IAAlarm.h"
#import "IAAlarmNotification.h"


#define    knotificationIdInIAAlarmNotification              @"knotificationIdInIAAlarmNotification"
#define    kalarmInIAAlarmNotification                       @"kalarmInIAAlarmNotification"
#define    ktimeStampInIAAlarmNotification                   @"ktimeStampInIAAlarmNotification"
#define    kviewedInIAAlarmNotification                      @"kviewedInIAAlarmNotification"
#define    kfireTimeStampInIAAlarmNotification               @"kfireTimeStampInIAAlarmNotification"
#define    ksoureAlarmNotificationInIAAlarmNotification      @"ksoureAlarmNotificationInIAAlarmNotification"

@implementation IAAlarmNotification

@synthesize notificationId, alarm, createTimeStamp, viewed, fireTimeStamp, soureAlarmNotification;


- (id)initWithAlarm:(IAAlarm*)theAlarm{
    return [self initWithAlarm:theAlarm fireTimeStamp:[NSDate date]];
}

- (id)initWithSoureAlarmNotification:(IAAlarmNotification*)theSoureAlarmNotification fireTimeStamp:(NSDate*)theFireTimeStamp{
    self = [self initWithAlarm:theSoureAlarmNotification.alarm fireTimeStamp:theFireTimeStamp];
    if (self) {
        soureAlarmNotification = [theSoureAlarmNotification retain];
    }
    return self;
}

- (id)initWithAlarm:(IAAlarm*)theAlarm fireTimeStamp:(NSDate*)theFireTimeStamp{
    self = [super init];
    if (self) {
        notificationId = [[NSString stringWithFormat:@"%@-%@",theAlarm.alarmId,YCSerialCode()] copy];
        alarm = [theAlarm retain];
        createTimeStamp = [[NSDate date] retain];
        viewed = NO;
        fireTimeStamp = [theFireTimeStamp retain];
    }
    return self;
}



- (void)dealloc{
    [notificationId release];
    [alarm release];
    [createTimeStamp release];
    [fireTimeStamp release];
    [soureAlarmNotification release];
    
    [super dealloc];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:notificationId forKey:knotificationIdInIAAlarmNotification];
	[encoder encodeObject:alarm forKey:kalarmInIAAlarmNotification];
	[encoder encodeObject:createTimeStamp forKey:ktimeStampInIAAlarmNotification];
	[encoder encodeBool:viewed forKey:kviewedInIAAlarmNotification];
    [encoder encodeObject:fireTimeStamp forKey:kfireTimeStampInIAAlarmNotification];
    [encoder encodeObject:soureAlarmNotification forKey:ksoureAlarmNotificationInIAAlarmNotification];
}

- (id)initWithCoder:(NSCoder *)decoder {
	
    self = [super init];
    if (self) {	
        notificationId = [[decoder decodeObjectForKey:knotificationIdInIAAlarmNotification] retain];
		alarm = [[decoder decodeObjectForKey:kalarmInIAAlarmNotification] retain];
		createTimeStamp = [[decoder decodeObjectForKey:ktimeStampInIAAlarmNotification] retain];
		viewed =[decoder decodeBoolForKey:kviewedInIAAlarmNotification];
        fireTimeStamp = [[decoder decodeObjectForKey:kfireTimeStampInIAAlarmNotification] retain];
        soureAlarmNotification = [[decoder decodeObjectForKey:ksoureAlarmNotificationInIAAlarmNotification] retain];
    }
    return self;
}

@end
