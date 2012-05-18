//
//  IAAlarmNotificationsCenter.m
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAAlarm.h"
#import "UIApplication+YC.h"
#import "IAAlarmNotification.h"
#import "IAAlarmNotificationCenter.h"

#define kAlarmNotificationCenterFilename @"alarmNotificationCenter.plist"

@implementation IAAlarmNotificationCenter

- (void)saveToFile{
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kAlarmNotificationCenterFilename];
    [NSKeyedArchiver archiveRootObject:allNotifications toFile:filePathName];
}

- (void)addNotification:(IAAlarmNotification*)notification{    
    [allNotifications insertObject:notification atIndex:0];
    [self saveToFile];
}

- (void)removeAllNotifications{
    [allNotifications removeAllObjects]; //加入一个空的列表    
    [self saveToFile];
}

- (void)removeFiredNotification{
    [self updateNotifications:[self notificationsForFired:NO]];
}

- (void)updateNotifications:(NSArray*)notifications{
    [allNotifications removeAllObjects];
    if (notifications && [notifications count] > 0) 
        [allNotifications addObjectsFromArray:notifications];
        
    [self saveToFile];
}

- (NSArray*)allNotifications{
    return allNotifications;
}

/*
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
 */

- (NSArray*)notificationsForFired:(BOOL)fired{
    NSDate *now = [NSDate date];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (IAAlarmNotification *anObj in allNotifications) {
        NSComparisonResult cr = [anObj.fireTimeStamp compare:now];
        BOOL add = (cr == NSOrderedDescending) ? !fired:fired;
        if (add) 
            [resultArray addObject:anObj];
    }
    
    return ([resultArray count] == 0) ? nil : resultArray;
}

- (NSArray*)notificationsForFired:(BOOL)fired soureAlarmNotification:(IAAlarmNotification*)soureAlarmNotification{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (IAAlarmNotification *anObj in [self notificationsForFired:fired]) {
        if ([anObj.soureAlarmNotification.notificationId isEqualToString:soureAlarmNotification.notificationId]) 
            [resultArray addObject:anObj];
    }
    
    return ([resultArray count] == 0) ? nil : resultArray;
}

- (NSArray*)notificationsForFired:(BOOL)fired alarmId:(NSString*)alarmId{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (IAAlarmNotification *anObj in [self notificationsForFired:fired]) {
        if ([alarmId isEqualToString:anObj.alarm.alarmId]) 
            [resultArray addObject:anObj];
    }
    
    return ([resultArray count] == 0) ? nil : resultArray;
}

- (IAAlarmNotification*)notificationOfId:(NSString*)noId{
    
    for (IAAlarmNotification *anObj in allNotifications) {
        if ([noId isEqualToString:anObj.notificationId] ) {
            return anObj;
        }
    }
    
    return nil;
}

static IAAlarmNotificationCenter *center = nil;
+ (IAAlarmNotificationCenter*)defaultCenter{
    if (center == nil) {
        center = [[super allocWithZone:NULL] init];
    }
    return center;
}

- (id)init{
    self = [super init];
    if (self) {
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kAlarmNotificationCenterFilename];  
        allNotifications  = [(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
        if (!allNotifications) 
            allNotifications = [[NSMutableArray array] retain];
    }
    return self;
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
