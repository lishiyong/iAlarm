//
//  IAAlarmNotificationsCenter.h
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IAAlarmNotification;
@interface IAAlarmNotificationCenter : NSObject

+ (id)defaultCenter;

- (void)addNotification:(IAAlarmNotification*)notification;
- (void)removeAllNotifications;
- (void)updateNotifications:(NSArray*)notifications;


- (NSArray*)allNotifications;
- (NSArray*)notificationsForViewed:(BOOL)viewed;

@end
