//
//  NSDate+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YC)

/**
 "上午10:5" 或 "10:5 AM"
 **/
- (NSString *)stringOfTimeShortStyle;

/**
 "周日上午10:5" 或 "Sunday 10:5 AM"
 **/
- (NSString *)stringOfTimeWeekDayShortStyle;

/**
 "周日" 或 "Sunday "
 **/
- (NSString *)stringOfTimeOnlyWeekDayStyle;

/*
 *创建一个新的NSDate,日期，时间分别来自不同部分
 */
+ (NSDate *)dateWithDate:(NSDate *)date time:(NSDate *)time;

@end
