//
//  IAAlarmNotify.h
//  iAlarm
//
//  Created by li shiyong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@class IAAlarm;
@interface IAAlarmNotification : NSObject

@property(nonatomic, readonly) IAAlarm *alarm;
@property(nonatomic, readonly) NSDate *timeStamp;
@property(nonatomic, getter = isViewed) BOOL viewed;

- (id)initWithAlarm:(IAAlarm*)theAlarm;

@end

