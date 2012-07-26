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
#define kNotification         @"kNotification"

@implementation IAAlarmCalendar

@synthesize name = _name, vaild = _vaild, beginTime = _beginTime, endTime = _endTime, repeatInterval = _repeatInterval, firstFireDate = _firstFireDate, notification = _notification, weekDay = _weekDay;

- (BOOL)endTimeInNextDay{
    NSDate *newEndTime = [NSDate dateWithDate:self.beginTime time:_endTime ];
    if ([newEndTime compare:self.beginTime] == NSOrderedAscending) { //endTime 比 beginTime早，endTime放到下一天
        return YES;
    }
    return NO;
}

- (void)setBeginTime:(NSDate *)beginTime{
    [beginTime retain];
    [_beginTime release];
    _beginTime = [beginTime copy];
    [beginTime release];
    
    //开始时间改变了，_firstFireDate需要重现生成
    [_firstFireDate release];
    _firstFireDate = nil;
    [self firstFireDate];//生成
}


- (id)beginTime{
    NSDate *now = [NSDate date];
    NSDate *newBeginTime = [NSDate dateWithDate:now time:_beginTime ];
    if (-1 !=_weekDay) {
        
        NSUInteger units = NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit;
        NSDateComponents *thisWeekBeginTimeComponents = [[NSCalendar currentCalendar] components:units fromDate:newBeginTime];
        thisWeekBeginTimeComponents.weekday = _weekDay;
        newBeginTime = [[NSCalendar currentCalendar] dateFromComponents:thisWeekBeginTimeComponents];
    }
    return newBeginTime;
}

- (id)endTime{
    NSDate *newEndTime = [NSDate dateWithDate:self.beginTime time:_endTime ];
    if ([newEndTime compare:self.beginTime] == NSOrderedAscending) { //endTime 比 beginTime早，endTime放到下一天
        newEndTime = [newEndTime dateByAddingTimeInterval:60.0*60*24];
    }
    return newEndTime;
}

- (id)firstFireDate{
    
    if (_firstFireDate == nil) {
         NSDate *now = [NSDate date];
        
        if (_weekDay != -1){
            
            if ([self.beginTime compare:now] == NSOrderedAscending) { //本周的开始时间比 now 早，_firstFireDate放到下一周
                _firstFireDate = [[self.beginTime dateByAddingTimeInterval:60.0*60*24*7] retain];
            }else {
                _firstFireDate = [self.beginTime retain];
            }
        }else { //
            if ([self.beginTime compare:now] == NSOrderedAscending) { //开始时间比 now 早，_firstFireDate放到下一天
                _firstFireDate = [[self.beginTime dateByAddingTimeInterval:60.0*60*24] retain];
            }else {
                _firstFireDate = [self.beginTime retain];
            }
        }

        
    }
    return _firstFireDate;
}

- (id)nextTimeFireDate{
  
    NSDate *nextTimeFireDate = nil;

    NSTimeInterval ti = [self.firstFireDate timeIntervalSinceNow];
    if (ti >= 0.0) {
        nextTimeFireDate = self.firstFireDate;
    }else {
        NSInteger i = 0;
        if (_weekDay != -1){
            i = 7;
        }else { //
            i = 1;
        }
        
        NSUInteger day = (NSUInteger) (ti / (60*60*24*i));
        BOOL hasR = ( ((NSUInteger)ti) % (60*60*24*i) == 0 ) ? NO : YES ; 
        day = day + (hasR ? i : 0) ;
        
        nextTimeFireDate = [self.firstFireDate dateByAddingTimeInterval:60.0*60*24*day];
    }
    
    //NSLog(@"firstFireDate = %@",[_firstFireDate debugDescription]);
    //NSLog(@"nextTimeFireDate = %@",[nextTimeFireDate debugDescription]);
    return nextTimeFireDate;
}


- (void)scheduleLocalNotificationWithAlarmId:(NSString *)alarmId title:(NSString *)title message:(NSString *)message soundName:(NSString *)soundName{

    [self cancelLocalNotification];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:alarmId forKey:@"kLaunchIAlarmLocalNotificationKey"];
    
    NSString *iconString = nil;//这是钟表🕘
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
        iconString = @"\U0001F558";
    else 
        iconString = @"\ue02c";
    
    NSString *alertTitle =  [NSString stringWithFormat:@"%@%@",iconString,title]; 
    NSString *alertMessage = nil;
    if (message) 
        alertMessage = message;
    else 
        alertMessage = @"单点这条消息，来启动位置闹钟！";
    NSString *notificationBody = [NSString stringWithFormat:@"%@: %@",alertTitle,alertMessage];
    
    _notification = [[UILocalNotification alloc] init];
    _notification.fireDate = self.nextTimeFireDate;    
    _notification.timeZone = [NSTimeZone defaultTimeZone];
    _notification.repeatInterval = self.repeatInterval;
    _notification.soundName = soundName;
    _notification.alertBody = notificationBody;
    _notification.userInfo = userInfo;
    _notification.applicationIconBadgeNumber = 1;//
    
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:_notification];
    
}

- (void)cancelLocalNotification{
    //先取消
    if (_notification) { 
        UIApplication *app = [UIApplication sharedApplication];
        [app cancelLocalNotification:_notification];
        [_notification release];
        _notification = nil;
    }
}

- (id)init{
    self = [super init];
    if (self) {
        _vaild = YES;
        _weekDay = -1;
        
        //初始化beginTime,endTime;
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
    [encoder encodeObject:_notification forKey:kNotification];
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
        _notification = [[decoder decodeObjectForKey:kNotification] retain];
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
    //copy->_notification = [_notification copy]; //_notification 不copy，因为dealloc的时候要取消_notification
    return copy;
}


- (void)dealloc{
    NSLog(@"IAAlarmCalendar dealloc");
    [self cancelLocalNotification]; //如果发送过，就需要取消
    
    [_name release];
    [_beginTime release];
    [_endTime release];
    [_firstFireDate release];
    [_notification release];
    [super dealloc];
}


@end
