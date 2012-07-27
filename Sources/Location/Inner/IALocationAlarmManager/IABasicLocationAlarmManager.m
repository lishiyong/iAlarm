//
//  IARegionMonitoringLocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IALocationManager.h"
#import "YCLog.h"
#import "IAGlobal.h"
#import "IASaveInfo.h"
#import "IANotifications.h"
#import "YCSystemStatus.h"
#import "IARegionsCenter.h"
#import "IARegion.h"
#import "IABasicLocationAlarmManager.h"

@interface IABasicLocationAlarmManager (private)

@property(nonatomic,readonly) CLLocationManager *locationManager;
- (void)start;
- (void)stop;
- (void)checkLocationData:(CLLocation*)locationData;

@end

@implementation IABasicLocationAlarmManager

#pragma mark - 覆盖父类

- (id)initWithDelegate:(id)delegate{
    self = [super initWithDelegate:delegate];
    if (self) {
        _locationManager = [[IALocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
		_locationManager.delegate = self;
        
        [self registerNotifications];
        
        //[IARegionsCenter sharedRegionCenter];
        [self start];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)location{
    return _locationManager.location;
}

- (void)dealloc{
    [self stop];
    [_locationManager release];
    [self unRegisterNotifications];
    [super dealloc];
}

#pragma mark - 私有

- (void)start{
    [_locationManager startUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)stop{
    [_locationManager stopUpdatingLocation];
    [_locationManager stopMonitoringSignificantLocationChanges];
}


//与IALocationManager 相同
- (void)checkLocationData:(CLLocation*)locationData{
	
    NSString *ss = [NSString stringWithFormat:@"执行了检测，数据精度 = %.f",locationData.horizontalAccuracy];
    [[YCLog logSingleInstance] addlog:ss];
    
	BOOL canChange = [[IARegionsCenter sharedRegionCenter] canChangeUserLocationTypeForCoordinate:locationData.coordinate];
	if (canChange) { //定位数据能改变某个区域的状态

		//调用代理
		for (IARegion *region in [[IARegionsCenter sharedRegionCenter].regions allValues]) {
			IAUserLocationType currentType = [region containsCoordinate:locationData.coordinate];
			
            /*
			if (locationData.horizontalAccuracy > kMiddleAccuracyThreshold) {
				if (region.region.radius < kRadiusAccuracyRateWhenLowAccuracyThreshold * locationData.horizontalAccuracy) {
					NSString *s = [NSString stringWithFormat:@"精度太低 而 半径又较小，不能确认是否到达！,精度 = %.f,半径 = %.f",locationData.horizontalAccuracy,region.region.radius];
                    [[YCLog logSingleInstance] addlog:s];
					continue;
				}
			}
             */
            
			if (currentType != region.userLocationType) {
				
				if (IAUserLocationTypeInner == currentType){
					
					[self.delegate locationManager:self didEnterRegion:region];
					region.userLocationType = currentType;
					
					
				}else if(IAUserLocationTypeOuter == currentType){
					
					[self.delegate locationManager:self didExitRegion:region];
					region.userLocationType = currentType;
    
					
				}else {
					//不处理边缘情况
					//region.userLocationType = IAUserLocationTypeOuter; //防止以外产生的边缘类型
				}
				
				
			}
			
		}//end for

	}
    
}



#pragma mark -
#pragma mark Notification

- (void)handle_applicationDidBecomeActive:(NSNotification*)notification {
    [self start];
}

- (void) handle_applicationWillResignActive:(id)notification{	
    IARegionsCenter *regionsCenter = [IARegionsCenter sharedRegionCenter];
    if ([regionsCenter.regions count] <= 0) {
        [self stop];
    }   
}

- (void) handle_regionsDidChange:(NSNotification*)notification {
    IARegionsCenter *regionsCenter = [IARegionsCenter sharedRegionCenter];
    UIApplication *app = [UIApplication sharedApplication];
    if ([regionsCenter.regions count] > 0 || app.applicationState == UIApplicationStateActive) {
        [self start];
    }else{
        [self stop];
    }
}


- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_regionsDidChange:)
							   name: IARegionsDidChangeNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidBecomeActive:)
							   name: UIApplicationDidBecomeActiveNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
    
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IARegionsDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidBecomeActiveNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}


#pragma mark - CLLocationManagerDelegate

- (void)sendStandardLocationDidFinishNotificationWithLocation:(CLLocation*)location{
	
    //////////////////////////////////////////////////////////////
    //发送接到定位数据通知
    NSDictionary *userInfo = nil;
    if (location)
        userInfo = [NSDictionary dictionaryWithObject:location forKey:IAStandardLocationKey];
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAStandardLocationDidFinishNotification 
                                                                  object:self 
                                                                userInfo:userInfo];
    //[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    [notificationCenter postNotification:aNotification];
    
    //////////////////////////////////////////////////////////////
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    [[YCLog logSingleInstance] addlog:@"定位通知 locationManager didUpdateToLocation"];
    //删除无效闹钟,增加有效的
    [[IARegionsCenter sharedRegionCenter] checkRegionsForRemove];
    //[[IARegionsCenter sharedRegionCenter] checkAlarmsForAdd];
    
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) > 5.0) {
		return;
	}

    
    [YCSystemStatus sharedSystemStatus].lastLocation = newLocation;//收集last数据
    //////////////////////////////////////////////////////////////
    //程序在前台，发送接到定位数据通知
    UIApplication* app = [UIApplication sharedApplication];
	if	(UIApplicationStateActive == app.applicationState){
        [self sendStandardLocationDidFinishNotificationWithLocation:newLocation];
    }
    //////////////////////////////////////////////////////////////
    
    
    IARegionsCenter *regionsCenter = [IARegionsCenter sharedRegionCenter];
    if ([regionsCenter.regions count] >0) {
        
        if (oldLocation) {
            if ((oldLocation.horizontalAccuracy - newLocation.horizontalAccuracy) > 1.0 ){
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
            }
        }
        [self performSelector:@selector(checkLocationData:) withObject:newLocation afterDelay:8.0]; //等5秒后在执行

    }
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[YCSystemStatus sharedSystemStatus].lastLocation = nil;
    //////////////////////////////////////////////////////////////
    //程序在前台，发送接到定位数据通知
    UIApplication* app = [UIApplication sharedApplication];
	if	(UIApplicationStateActive == app.applicationState){
		[self sendStandardLocationDidFinishNotificationWithLocation:nil];
    }
    //////////////////////////////////////////////////////////////    
}


@end
