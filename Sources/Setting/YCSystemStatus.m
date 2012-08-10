//
//  YCDeviceStatus.m
//  iAlarm
//
//  Created by li shiyong on 10-11-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "YCLog.h"
#import "IAAlarm.h"
#import "IANotifications.h"
#import "iAlarmAppDelegate.h"
#import "YCSystemStatus.h"
#import "IALocationAlarmManager.h"
#import "Reachability.h"

#define kSystemStatusFilename @"systemStatus.plist"
static NSString *kAlreadyRateKey                     = @"kAlreadyRateKey";
static NSString *kNotToRemindRateKey                 = @"kNotToRemindRateKey";

@implementation YCSystemStatus
@synthesize isAlarmListEditing = _isAlarmListEditing, lastLocation = _lastLocation;

- (void)setLastLocation:(CLLocation *)lastLocation{
    
    BOOL wirteToFile = NO;
    if (lastLocation) { //nil不写入文件
        if (_lastWritedLocation) {
            CLLocationDistance distance = [lastLocation distanceFromLocation:_lastWritedLocation];
            if (distance > 100.0) {//与上次写入的差值100以上，才写入
                wirteToFile = YES;
            }
        }else{
            wirteToFile = YES;
        }
    }
    
    if (wirteToFile) {
        [_lastWritedLocation release];
        _lastWritedLocation = [lastLocation retain];
        
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kSystemStatusFilename];
        [NSKeyedArchiver archiveRootObject:_lastWritedLocation toFile:filePathName];
    }
    
    [lastLocation retain];
	[_lastLocation release];
	_lastLocation = lastLocation;
    
}

- (BOOL)isAlarmListEditing{
	NSUInteger alarmsCount = [IAAlarm alarmArray].count;		//空列表不能是编辑状态
	if (alarmsCount <= 0){
		_isAlarmListEditing = NO;
	}

	return _isAlarmListEditing;
}


- (BOOL)connectedToInternet
{
	BOOL retVal = NO;
	Reachability *internetReach = [Reachability reachabilityForInternetConnection];
	if (!internetReach.connectionRequired) 
	{
		switch (internetReach.currentReachabilityStatus) {
			case ReachableViaWiFi:
			case ReachableViaWWAN:
				retVal = YES;
				break;
			default:
				retVal = NO;
				break;
		}
	}
	
	return retVal;
}
- (BOOL)enabledLocation
{
	BOOL b = [CLLocationManager locationServicesEnabled];
	if (b) {
		if ([CLLocationManager respondsToSelector:@selector(authorizationStatus)]) //iOS4.2版本后才支持
			b = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
	}
	return b;
	
}

- (void)handle_alarmListEditStateDidChange:(NSNotification*) notification {
	NSNumber *isEditingObj = [[notification userInfo] objectForKey:IAEditStatusKey];
	self.isAlarmListEditing = [isEditingObj boolValue];
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmListEditStateDidChange:)
							   name: IAAlarmListEditStateDidChangeNotification
							 object: nil];
	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: IAAlarmListEditStateDidChangeNotification object: nil];
}


//是否已经评论过 
- (BOOL)alreadyRate{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kAlreadyRateKey];
	if (number == nil) {
		return NO;
	}
	return [number boolValue];
}
- (void)setAlreadyRate:(BOOL)b{
	NSNumber *number = [NSNumber numberWithBool:b];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: kAlreadyRateKey];
	[defaults synchronize];	
}

//是否不再评论 
- (BOOL)notToRemindRate{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kNotToRemindRateKey];
	if (number == nil) {
		return NO;
	}
	return [number boolValue];
}
- (void)setNotToRemindRate:(BOOL)b{
	NSNumber *number = [NSNumber numberWithBool:b];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: kNotToRemindRateKey];
	[defaults synchronize];	
}


+(YCSystemStatus*) sharedSystemStatus
{
	static YCSystemStatus* obj = nil;
	if (obj == nil) {
		obj = [[YCSystemStatus alloc] init];
		[obj retain];
	}
	
	return obj;
	
}

- (id)init{
	if (self = [super init]) {
		[self registerNotifications];
        
        //读出一下存储的数据
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kSystemStatusFilename];
        _lastLocation = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
	}
	return self;
}

- (void)dealloc {
	[self unRegisterNotifications];
	[_lastLocation release];
    [super dealloc];
}

@end
