//
//  IAAlarmCalendar.m
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
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
    
    //开始时间改变了，_firstFireDate需要重现生成
    [_firstFireDate release];
    _firstFireDate = nil;
}


- (id)beginTime{
    NSDate *now = [NSDate date];
    return [NSDate dateWithDate:now time:_beginTime ];
}

- (id)endTime{
    NSDate *now = [NSDate date];
    NSDate *newEndTime = [NSDate dateWithDate:now time:_endTime ];
    if ([newEndTime compare:self.beginTime] == NSOrderedAscending) { //endTime 比 beginTime早，endTime放到下一天
        newEndTime = [newEndTime dateByAddingTimeInterval:60*60*24];
    }
    return newEndTime;
}


- (NSDate*)firstFireDate{
    
    if (_firstFireDate == nil) {
        NSDate *now = [NSDate date];    
        _firstFireDate = [[NSDate dateWithDate:now time:_beginTime] retain];
        
        if ([_firstFireDate compare:now] == NSOrderedAscending){//_beginTime比现在早。所以第一个通知日期是下一天        
            NSDate *temp = [_firstFireDate dateByAddingTimeInterval:60*60*24];
            [_firstFireDate release];
            _firstFireDate = [temp retain];
        }
    }
    
    return _firstFireDate;
}

- (id)init{
    self = [super init];
    if (self) {
        _vaild = YES;
        
        NSDateComponents *beginComponents = [[[NSDateComponents alloc] init] autorelease];
        NSDateComponents *endComponents = [[[NSDateComponents alloc] init] autorelease];
        beginComponents.hour = 8; //上午8点
        beginComponents.minute = 0;
        endComponents.hour = 20;//下午8点
        endComponents.minute = 0;
        
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        currentCalendar.timeZone = [NSTimeZone defaultTimeZone];
        _beginTime = [[currentCalendar dateFromComponents:beginComponents] retain];
        _endTime = [[currentCalendar dateFromComponents:endComponents] retain];
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
