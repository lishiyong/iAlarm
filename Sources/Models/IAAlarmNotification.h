//
//  IAAlarmNotify.h
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@class IAAlarm;
@interface IAAlarmNotification : NSObject<NSCoding>

@property(nonatomic, readonly) NSString *notificationId;
@property(nonatomic, readonly) IAAlarm *alarm;
@property(nonatomic, readonly) NSDate *createTimeStamp;
@property(nonatomic, getter = isViewed) BOOL viewed;
@property(nonatomic, readonly) NSDate *fireTimeStamp;;

- (id)initWithAlarm:(IAAlarm*)theAlarm ;
- (id)initWithAlarm:(IAAlarm*)theAlarm fireTimeStamp:(NSDate*)fireTimeStamp;

@end

