//
//  IAAlarmNotificationsCenter.h
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IAAlarmNotification;
@interface IAAlarmNotificationCenter : NSObject{
    NSMutableArray *allNotifications;
}

+ (IAAlarmNotificationCenter*)defaultCenter;

- (void)addNotification:(IAAlarmNotification*)notification;
- (void)removeAllNotifications;
- (void)updateNotifications:(NSArray*)notifications;
- (void)removeFiredNotification;


- (NSArray*)allNotifications;
//- (NSArray*)notificationsForViewed:(BOOL)viewed;
- (NSArray*)notificationsForFired:(BOOL)fired;
- (IAAlarmNotification*)notificationOfId:(NSString*)noId;

@end
