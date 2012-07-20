//
//  IAAlarmCalendar.m
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAAlarmCalendar.h"

#define kName                 @"kName"
#define kVaild                @"kVaild"
#define kBeginTime            @"kBeginTime"
#define kEndTime              @"kEndTime"
#define kRepeatInterval       @"kRepeatInterval"
#define kFirstFireDate        @"kFirstFireDate"

@implementation IAAlarmCalendar

@synthesize name = _name, vaild = _vaild, beginTime = _beginTime, endTime = _endTime, repeatInterval = _repeatInterval, firstFireDate = _firstFireDate;

- (void)setBeginTime:(NSDate *)beginTime{
    [beginTime retain];
    [_beginTime release];
    _beginTime = [beginTime copy];
    [beginTime release];
    
    NSDate *now = [NSDate date];
    if ([_beginTime compare:now] == NSOrderedDescending){//_beginTime比现在晚
        //TODO
    }
}

- (id)init{
    self = [super init];
    if (self) {
        _vaild = YES;
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"HH:mm"];
        _beginTime = [[dateFormatter dateFromString:@"08:00"] retain];
        _endTime = [[dateFormatter dateFromString:@"21:00"] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:kName];
    [encoder encodeBool:_vaild forKey:kVaild];
	[encoder encodeObject:_beginTime forKey:kBeginTime];
	[encoder encodeObject:_endTime forKey:kEndTime];
    [encoder encodeInteger:_repeatInterval forKey:kRepeatInterval];
    [encoder encodeObject:_firstFireDate forKey:kFirstFireDate];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {	
        _name = [[decoder decodeObjectForKey:kName] retain];
        _vaild = [decoder decodeBoolForKey:kVaild];
		_beginTime = [[decoder decodeObjectForKey:kBeginTime] retain];
		_endTime = [[decoder decodeObjectForKey:kEndTime] retain];
        _repeatInterval = [decoder decodeIntegerForKey:kRepeatInterval];
        _firstFireDate = [[decoder decodeObjectForKey:kFirstFireDate] retain];
    }
    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	
	IAAlarmCalendar *copy = [[[self class] allocWithZone: zone] init];
    copy.name = _name;
    copy.vaild = _vaild;
    copy.beginTime = _beginTime;
    copy.endTime = _endTime;
    copy.repeatInterval = _repeatInterval;
    return copy;
}


- (void)dealloc{
    [_name release];
    [_beginTime release];
    [_endTime release];
    [_firstFireDate release];
    [super dealloc];
}


@end
