//
//  NSDateComponents+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDateComponents+YC.h"

@implementation NSDateComponents (YC)

- (void)setDateComponentsWithAnotherDateComponents:(NSDateComponents*)anotherDateComponents{    
    if (NSUndefinedDateComponent != anotherDateComponents.era) {
        self.era = anotherDateComponents.era;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.year) {
        self.year = anotherDateComponents.year;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.yearForWeekOfYear) {
        self.yearForWeekOfYear = anotherDateComponents.yearForWeekOfYear;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.quarter) {
        self.quarter = anotherDateComponents.quarter;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.month) {
        self.month = anotherDateComponents.month;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.week) {
        self.week = anotherDateComponents.week;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.weekday) {
        self.weekday = anotherDateComponents.weekday;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.weekdayOrdinal) {
        self.weekdayOrdinal = anotherDateComponents.weekdayOrdinal;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.weekOfMonth) {
        self.weekOfMonth = anotherDateComponents.weekOfMonth;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.weekOfYear) {
        self.weekOfYear = anotherDateComponents.weekOfYear;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.day) {
        self.day = anotherDateComponents.day;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.hour) {
        self.hour = anotherDateComponents.hour;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.minute) {
        self.minute = anotherDateComponents.minute;
    }
    
    if (NSUndefinedDateComponent != anotherDateComponents.second) {
        self.second = anotherDateComponents.second;
    }
    
}


@end
