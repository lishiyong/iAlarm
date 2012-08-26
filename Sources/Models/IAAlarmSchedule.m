//
//  IAAlarmCalendar.m
//  iAlarm
//
//  Created by li shiyong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalizedString.h"
#import "IARegionsCenter.h"
#import "YCLib.h"
#import "IAAlarmSchedule.h"

#define kName                 @"kName"
#define kVaild                @"kVaild"
#define kBeginTime            @"kBeginTime"
#define kEndTime              @"kEndTime"
#define kRepeatInterval       @"kRepeatInterval"
#define kFirstFireDate        @"kFirstFireDate"
#define kNotification         @"kNotification"
#define kWeekday              @"kWeekday"

@implementation IAAlarmSchedule

@synthesize name = _name, vaild = _vaild, beginTime = _beginTime, endTime = _endTime, repeatInterval = _repeatInterval, firstFireDate = _firstFireDate, weekDay = _weekDay;

- (BOOL)endTimeInNextDay{
    NSDate *newEndTime = [NSDate dateWithDate:self.beginTime time:_endTime ];
    if ([newEndTime compare:self.beginTime] != NSOrderedDescending) { //endTime 比 beginTime早，endTime放到下一天
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
    if (nil == _beginTime) {
        return nil;
    }
    
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
    if (nil == _endTime) {
        return nil;
    }
    
    NSDate *newEndTime = [NSDate dateWithDate:self.beginTime time:_endTime ];
    if ([newEndTime compare:self.beginTime] != NSOrderedDescending) { //endTime 比 beginTime早，endTime放到下一天
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
    if (ti > 0.0) {
        nextTimeFireDate = self.firstFireDate;
    }else {
        NSInteger i = 0;
        if (_weekDay != -1){
            i = 7;
        }else { //
            i = 1;
        }
        
        NSUInteger day = (NSUInteger) (ti / (60*60*24*i));
        BOOL hasR = ( ((NSUInteger)fabs(ti)) % (60*60*24*i) == 0 ) ? NO : YES ; 
        day = day + (hasR ? i : 0) ;
        
        nextTimeFireDate = [self.firstFireDate dateByAddingTimeInterval:60.0*60*24*day];
    }
    
    //NSLog(@"firstFireDate = %@",[_firstFireDate debugDescription]);
    //NSLog(@"nextTimeFireDate = %@",[nextTimeFireDate debugDescription]);
    return nextTimeFireDate;
}


- (void)scheduleLocalNotificationWithAlarmId:(NSString *)alarmId title:(NSString *)title message:(NSString *)message soundName:(NSString *)soundName{

    //
    [self cancelLocalNotification];
    
    //
    NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [notificationUserInfo setObject:alarmId forKey:@"kLaunchIAlarmLocalNotificationKey"];
    
    NSString *iconString = [NSString stringEmojiClockFaceNine];//这是钟表🕘    
    NSString *alertMessage = nil;
    if (message) 
        alertMessage = message;
    else 
        alertMessage = KTextNotificationLaunchAlarm;
    
    if (title == nil) title = @"";
    NSString *notificationBody = [NSString stringWithFormat:@"%@%@: %@", iconString, alertMessage, title];
    
    _notification = [[UILocalNotification alloc] init];    
    _notification.fireDate = [self.nextTimeFireDate dateByAddingTimeInterval:5.0];//延后1秒    
    _notification.timeZone = [NSTimeZone defaultTimeZone];
    _notification.repeatInterval = self.repeatInterval;
    _notification.soundName = soundName;
    _notification.alertBody = notificationBody;
    _notification.userInfo = notificationUserInfo;
    _notification.applicationIconBadgeNumber = 1;//
    _notification.alertAction = KTitleLaunch;
    _notification.alertLaunchImage = @"Default.png";
    
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:_notification];
    
    
    //如果程序有执行能力()，timer将把闹钟启动，并取消本次本地通知
    NSTimeInterval ti = (_weekDay == -1) ? 60.0*60*24 : 60.0*60*24*7;
    NSDate *timeFireDate = [self.nextTimeFireDate dateByAddingTimeInterval:1.0];//延后1秒
    //NSDictionary *timerUserInfo = [NSDictionary dictionaryWithObject:_notification forKey:@"kAlarmScheduleNotificationKey"];
    
    [_timer invalidate];
    [_timer release];
    _timer = [[NSTimer alloc] initWithFireDate:timeFireDate interval:ti target:[IARegionsCenter sharedRegionCenter] selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

- (void)cancelLocalNotification{
    
    //
    [_timer invalidate];
    [_timer release];
    _timer = nil;
    
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
    [encoder encodeInteger:_repeatInterval forKey:kRepeatInterval];
	[encoder encodeObject:_beginTime forKey:kBeginTime];
	[encoder encodeObject:_endTime forKey:kEndTime];
    [encoder encodeObject:_firstFireDate forKey:kFirstFireDate];
    [encoder encodeInteger:_weekDay forKey:kWeekday];
    [encoder encodeObject:_notification forKey:kNotification];
    
    //_timer 不支持 NSCoding
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {	
        _name = [[decoder decodeObjectForKey:kName] retain];
        _vaild = [decoder decodeBoolForKey:kVaild];
        _repeatInterval = [decoder decodeIntegerForKey:kRepeatInterval];
		_beginTime = [[decoder decodeObjectForKey:kBeginTime] retain];
		_endTime = [[decoder decodeObjectForKey:kEndTime] retain];
        _firstFireDate = [[decoder decodeObjectForKey:kFirstFireDate] retain];
        _weekDay = [decoder decodeIntegerForKey:kWeekday];
        _notification = [[decoder decodeObjectForKey:kNotification] retain];
        
        //_timer 不支持 NSCoding
    }
    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	
	IAAlarmSchedule *copy = [[[self class] allocWithZone: zone] init];
    copy->_name = [_name copy];
    copy->_vaild = _vaild;
    copy->_repeatInterval = _repeatInterval;
    copy->_beginTime = [_beginTime copy];
    copy->_endTime = [_endTime copy];
    copy->_firstFireDate = [_firstFireDate copy];
    copy->_weekDay = _weekDay;
    
    //_notification,_timer 不用copy
    
    return copy;
}


- (void)dealloc{
    //NSLog(@"IAAlarmCalendar dealloc");
    [self cancelLocalNotification]; //如果发送过，就需要取消
    
    [_name release];
    [_notification release];
    [_beginTime release];
    [_endTime release];
    [_firstFireDate release];
    [_timer invalidate]; [_timer release];
    [super dealloc];
}


@end
