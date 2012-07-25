//
//  NSDate+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDateComponents+YC.h"
#import "NSDate+YC.h"

@implementation NSDate (YC)

/*
- (NSString *)description{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:kCFDateFormatterShortStyle];
    [formatter setTimeStyle:kCFDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatter setLocale:[NSLocale systemLocale]];
    return [formatter stringFromDate:self];
}
 */

- (NSString *)debugDescription{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:kCFDateFormatterLongStyle];
    [formatter setTimeStyle:kCFDateFormatterShortStyle];
    //[formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    //[formatter setLocale:[NSLocale systemLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)stringOfTimeShortStyle{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:kCFDateFormatterNoStyle];
    [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringOfTimeWeekDayShortStyle{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"EEE"];
    NSString  *weekday = [dateFormatter stringFromDate:self];
    return [NSString stringWithFormat:@"%@, %@",weekday,[self stringOfTimeShortStyle]];
}

+ (NSDate *)dateWithDate:(NSDate *)date time:(NSDate *)time{
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    currentCalendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSUInteger dateUnits = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) ;
    NSUInteger timeUnits = (NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
    NSDateComponents *dateComponents = [currentCalendar components:dateUnits fromDate:date];
    NSDateComponents *timeComponents = [currentCalendar components:timeUnits fromDate:time]; 
    
    NSDateComponents *newDateComponents = [[[NSDateComponents alloc] init] autorelease];
    [newDateComponents setDateComponentsWithAnotherDateComponents:dateComponents];
    [newDateComponents setDateComponentsWithAnotherDateComponents:timeComponents];
    NSDate  *newDate = [currentCalendar dateFromComponents:newDateComponents];
    
    return newDate;
}

@end
