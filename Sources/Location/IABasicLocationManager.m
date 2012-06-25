//
//  IARegionMonitoringLocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLog.h"
#import "IAGlobal.h"
#import "IASaveInfo.h"
#import "IANotifications.h"
#import "YCSystemStatus.h"
#import "IARegionsCenter.h"
#import "IARegion.h"
#import "IABasicLocationManager.h"

@implementation IABasicLocationManager
@synthesize delegate;


-(CLLocationManager*)standardLocationManager
{
	if (standardLocationManager == nil) {
		standardLocationManager = [[CLLocationManager alloc] init];
		standardLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
		standardLocationManager.delegate = self;
	}
    
	return standardLocationManager;
}



- (void)start{
    running = YES;
    [self.standardLocationManager startUpdatingLocation];
    [self.standardLocationManager startMonitoringSignificantLocationChanges];
}

- (void)stop{
    running = NO;
    [self.standardLocationManager stopUpdatingLocation];
    [self.standardLocationManager stopMonitoringSignificantLocationChanges];
}


//与IALocationManager 相同
- (void)checkLocationData:(CLLocation*)locationData{
	
    NSString *ss = [NSString stringWithFormat:@"执行了检测，数据精度 = %.f,指针=%d",locationData.horizontalAccuracy,locationData];
    [[YCLog logSingleInstance] addlog:ss];
    
	BOOL canChange = [[IARegionsCenter regionCenterSingleInstance] canChangeUserLocationTypeForCoordinate:locationData.coordinate];
	if (canChange) { //定位数据能改变某个区域的状态
        
		//调用代理
		IARegionsCenter *regionsCenter = [IARegionsCenter regionCenterSingleInstance];
		
		for (IARegion *region in regionsCenter.regionArray) {
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

- (void) handle_applicationDidEnterBackground:(id) notification{
}

- (void)handle_applicationWillEnterForeground_DidFinishLaunching:(NSNotification*)notification {
	
	
}

- (void)handle_applicationDidBecomeActive:(NSNotification*)notification {
    if (running) {
        [self.standardLocationManager startUpdatingLocation]; 
        [self.standardLocationManager startMonitoringSignificantLocationChanges];
    }
}

- (void) handle_applicationWillResignActive:(id)notification{	
	//[YCSystemStatus sharedSystemStatus].lastLocation = nil;//免得下次使用了缓存
    
    IARegionsCenter *regionsCenter = [IARegionsCenter regionCenterSingleInstance];
    if ([regionsCenter.regions count] <= 0) {
        [self.standardLocationManager stopUpdatingLocation];
        [self.standardLocationManager stopMonitoringSignificantLocationChanges];
    }
   
}

- (void) handle_regionsDidChange:(NSNotification*)notification {
    
    IARegionsCenter *regionsCenter = [IARegionsCenter regionCenterSingleInstance];
    if ([regionsCenter.regions count] <= 0) {
        [self.standardLocationManager stopUpdatingLocation];
        [self.standardLocationManager stopMonitoringSignificantLocationChanges];
    }else{
        if (running) {
            [self.standardLocationManager startUpdatingLocation];
            [self.standardLocationManager startMonitoringSignificantLocationChanges];
        }
    }
}


- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_regionsDidChange:)
							   name: IARegionsDidChangeNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidEnterBackground:)
							   name: UIApplicationDidEnterBackgroundNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground_DidFinishLaunching:)
							   name: UIApplicationWillEnterForegroundNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground_DidFinishLaunching:)
							   name: UIApplicationDidFinishLaunchingNotification
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
	[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillEnterForegroundNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidFinishLaunchingNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidBecomeActiveNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}




#pragma mark - 
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

//#define EPS 1e-5
#define EPS 1.0
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) > 5.0) {
		return;
	}
    
    NSString *s = [NSString stringWithFormat:@"定位经度：%.f,指针:%p",newLocation.horizontalAccuracy,newLocation];
    [[YCLog logSingleInstance] addlog:s];

    
    [YCSystemStatus sharedSystemStatus].lastLocation = newLocation;//收集last数据
    //////////////////////////////////////////////////////////////
    //程序在前台，发送接到定位数据通知
    UIApplication* app = [UIApplication sharedApplication];
	if	(UIApplicationStateActive == app.applicationState){
        [self sendStandardLocationDidFinishNotificationWithLocation:newLocation];
    }
    //////////////////////////////////////////////////////////////
    
    
    IARegionsCenter *regionsCenter = [IARegionsCenter regionCenterSingleInstance];
    if ([regionsCenter.regions count] >0) {
        
        if (oldLocation) {
            if ((oldLocation.horizontalAccuracy - newLocation.horizontalAccuracy) > EPS ){
                NSString *ss = [NSString stringWithFormat:@"取消检测，精度:%.f,指针:%p",oldLocation.horizontalAccuracy,oldLocation];
                [[YCLog logSingleInstance] addlog:ss];
                //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkLocationData:) object:oldLocation];
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
            }
        }
        [self performSelector:@selector(checkLocationData:) withObject:newLocation afterDelay:8.0]; //等5秒后在执行

        
    }
     
    
    
    //NSLog(@"newLocation = %@ , oldLocation  = %@",newLocation,oldLocation);
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



- (id)init{
    self = [super init];
	if (self) {
		[self registerNotifications];
	}
	return self;
}

- (void)dealloc {
    
    [standardLocationManager stopMonitoringSignificantLocationChanges];
    [standardLocationManager stopUpdatingLocation];
	[standardLocationManager release];	
    [self unRegisterNotifications];
    
    [super dealloc];
}

@end
