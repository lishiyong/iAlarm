//
//  IAAlarmCalendar.h
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAAlarmCalendar : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic) BOOL vaild;
@property (nonatomic, copy) NSDate *beginTime;
@property (nonatomic, copy) NSDate *endTime;
@property (nonatomic) NSCalendarUnit repeatInterval;
@property (nonatomic, readonly) NSDate *firstFireDate;
@property (nonatomic, readonly) UILocalNotification *notification; //if nil, 通知没有发送过
@property (nonatomic, readonly) BOOL endTimeInNextDay; //结束时间是否在下一天
@property (nonatomic) NSInteger weekDay;  //默认－1,没有指定。1：周日 2：周1 ... 7：周六. 

/*
 *发送前会取消上一次发送的的通知，如果有的话。
 */
- (void)scheduleLocalNotificationWithAlarmId:(NSString *)alarmId title:(NSString *)title message:(NSString *)message soundName:(NSString *)soundName;

- (void)cancelLocalNotification;


@end
