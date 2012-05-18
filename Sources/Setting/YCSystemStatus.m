//
//  YCDeviceStatus.m
//  iAlarm
//
//  Created by li shiyong on 10-11-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIApplication+YC.h"
#import "YCLog.h"
#import "IAAlarm.h"
#import "IANotifications.h"
#import "IALocationManager.h"
#import "iAlarmAppDelegate.h"
#import "YCSystemStatus.h"
#import "IALocationManager.h"
#import "Reachability.h"

#define kSystemStatusFilename @"systemStatus.plist"


static NSString *ApplicationDidFinishLaunchNumberKey = @"ApplicationDidFinishLaunchNumberKey";
static NSString *ApplicationDidBecomeActiveNumberKey = @"ApplicationDidBecomeActiveNumberKey";
static NSString *AlarmAlertNumberNumberKey           = @"AlarmAlertNumberNumberKey";
static NSString *LastLocationKey                     = @"LastLocationKey";

static NSString *kAlreadyRateKey                     = @"kAlreadyRateKey";
static NSString *kNotToRemindRateKey                 = @"kNotToRemindRateKey";



@implementation YCSystemStatus
@synthesize localNotificationIdentifiers;
@synthesize canValidLocation;
@synthesize isAlarmListEditing;
@synthesize lastLocation;

- (void)setLastLocation:(CLLocation *)theLastLocation{

    if (theLastLocation != lastLocation) {
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kSystemStatusFilename];
        [NSKeyedArchiver archiveRootObject:theLastLocation toFile:filePathName];
    }
    
    [theLastLocation retain];
	[lastLocation release];
	lastLocation = theLastLocation;
    
}

/*
- (id)lastLocation{
    if (lastLocation == nil) {//为空的时候先读出一下存储的数据
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kSystemStatusFilename];
        lastLocation = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
    }
    return lastLocation;
}
 */

- (BOOL)isAlarmListEditing{
	NSUInteger alarmsCount = [IAAlarm alarmArray].count;		//空列表不能是编辑状态
	if (alarmsCount <= 0){
		isAlarmListEditing = NO;
	}

	return isAlarmListEditing;
}

- (id)localNotificationIdentifiers{
    if (localNotificationIdentifiers == nil) {
        localNotificationIdentifiers = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return localNotificationIdentifiers;
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



- (void)handle_standardLocationDidFinish:(NSNotification*) notification{
	//判断是否能定位
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
	if (location) {
		canValidLocation = YES;
	}else {
		canValidLocation = NO;
	}
}

- (void)handle_alarmListEditStateDidChange:(NSNotification*) notification {
	NSNumber *isEditingObj = [[notification userInfo] objectForKey:IAEditStatusKey];
	self.isAlarmListEditing = [isEditingObj boolValue];
}

- (void)handle_applicationDidFinishLaunching:(id)notification{
	NSInteger i = self.applicationDidFinishLaunchNumber;
	NSNumber *number = [NSNumber numberWithInteger:i+1];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: ApplicationDidFinishLaunchNumberKey];
	[defaults synchronize];
}

- (void)handle_applicationDidBecomeActive:(id)notification{
	NSInteger i = self.applicationDidBecomeActiveNumber;
	NSNumber *number = [NSNumber numberWithInteger:i+1];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: ApplicationDidBecomeActiveNumberKey];
	[defaults synchronize];
}


- (void)handle_alarmDidAlert:(id)notification{
	
	NSInteger i = self.alarmAlertNumber;
	NSNumber *number = [NSNumber numberWithInteger:i+1];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: AlarmAlertNumberNumberKey];
	[defaults synchronize];	
	
}



- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handle_standardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmListEditStateDidChange:)
							   name: IAAlarmListEditStateDidChangeNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidFinishLaunching:)
							   name: UIApplicationDidFinishLaunchingNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidBecomeActive:)
							   name: UIApplicationDidBecomeActiveNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmDidAlert:)
							   name: IAAlarmDidAlertNotification
							 object: nil];
    
    
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmListEditStateDidChangeNotification object: nil];
	
	[notificationCenter removeObserver:self	name: UIApplicationDidFinishLaunchingNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidBecomeActiveNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmDidAlertNotification object: nil];
}



- (NSInteger)applicationDidFinishLaunchNumber{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: ApplicationDidFinishLaunchNumberKey];
	if (number == nil) {
		return 0;
	}
	return [number integerValue];
}

- (NSInteger)applicationDidBecomeActiveNumber{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: ApplicationDidBecomeActiveNumberKey];
	if (number == nil) {
		return 0;
	}
	return [number integerValue];
}

- (NSInteger)alarmAlertNumber{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: AlarmAlertNumberNumberKey];
	if (number == nil) {
		return 0;
	}
	return [number integerValue];
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


+(YCSystemStatus*) deviceStatusSingleInstance
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
		canValidLocation = YES;//默认认为能有效定位
        
        //读出一下存储的数据
        NSString *filePathName =  [[UIApplication sharedApplication].libraryDirectory stringByAppendingPathComponent:kSystemStatusFilename];
        lastLocation = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePathName] retain];
	}
	return self;
}

- (void)dealloc {
	[self unRegisterNotifications];
	[lastLocation release];
    [localNotificationIdentifiers release];
    [super dealloc];
}




@end
