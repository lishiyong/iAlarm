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

+ (id)defaultCenter{
    static IAAlarmNotificationCenter *center = nil;
    if (!center) {
        center = [[IAAlarmNotificationCenter alloc] init];
    }
    return center;
}

- (void)addNotification:(IAAlarmNotification*)notification{
    NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kAlarmNotificationCenterFilename];
    
    NSMutableArray *allNotifications = (NSMutableArray*)[self allNotifications];
    if (!allNotifications) 
        allNotifications = [NSMutableArray array];
    [allNotifications addObject:notification];
    
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




@end
