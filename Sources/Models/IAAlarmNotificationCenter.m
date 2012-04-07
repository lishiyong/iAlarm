//
//  IAAlarmNotificationsCenter.m
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIApplication-YC.h"
#import "IAAlarmNotification.h"
#import "IAAlarmNotificationCenter.h"

#define kAlarmNotificationCenterFilename @"alarmNotificationCenter.plist"

@implementation IAAlarmNotificationCenter

static IAAlarmNotificationCenter *center = nil;
+ (IAAlarmNotificationCenter*)defaultCenter{
    if (center == nil) {
        center = [[super allocWithZone:NULL] init];
    }
    return center;
}

- (void)addNotification:(IAAlarmNotification*)notification{
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kAlarmNotificationCenterFilename];
    
    NSMutableArray *allNotifications = (NSMutableArray*)[self allNotifications];
    if (!allNotifications) 
        allNotifications = [NSMutableArray array];
    [allNotifications insertObject:notification atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:allNotifications toFile:filePathName];
}

- (void)removeAllNotifications{
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kAlarmNotificationCenterFilename];
    
    NSArray *allNotifications = [NSArray array]; //加入一个空的列表    
    [NSKeyedArchiver archiveRootObject:allNotifications toFile:filePathName];
}


- (void)updateNotifications:(NSArray*)notifications{
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kAlarmNotificationCenterFilename];
    
    [NSKeyedArchiver archiveRootObject:notifications toFile:filePathName];
}

- (NSArray*)allNotifications{
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kAlarmNotificationCenterFilename];  
    
    NSArray *notifications  = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName];
    return notifications;
}

- (NSArray*)notificationsForViewed:(BOOL)viewed{
    
    NSMutableArray *allNotifications = (NSMutableArray*)[self allNotifications];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (IAAlarmNotification *anObj in allNotifications) {
        if (viewed == anObj.isViewed ) {
            [resultArray addObject:anObj];
        }
    }
    
    return ([resultArray count] == 0) ? nil : resultArray;
    
}


+ (id)allocWithZone:(NSZone *)zone
{
    return [[self defaultCenter] retain];
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
