//
//  IAAlarmCalendar.h
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAAlarmCalendar : NSObject <NSCoding>

@property (nonatomic, retain) NSString *name;
@property (nonatomic) BOOL vaild;
@property (nonatomic, retain) NSDate *beginTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic) NSCalendarUnit repeatInterval;
@property (nonatomic, retain) NSDate *firstFireDate;


@end
