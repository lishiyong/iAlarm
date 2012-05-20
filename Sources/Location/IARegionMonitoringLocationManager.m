//
//  IARegionMonitoringLocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IASaveInfo.h"
#import "IANotifications.h"
#import "YCSystemStatus.h"
#import "IARegionsCenter.h"
#import "IARegion.h"
#import "IARegionMonitoringLocationManager.h"

@implementation IARegionMonitoringLocationManager
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

- (void)startAllRegionsMonitoring{    
    NSDictionary *regions = [IARegionsCenter regionCenterSingleInstance].regions;
    for (IARegion *anIAregion in [regions allValues]) {
        CLRegion *anRegion = anIAregion.region;
        [self.standardLocationManager startMonitoringForRegion:anRegion desiredAccuracy:anIAregion.monitoringForRegionDesiredAccuracy];
        NSLog(@"全部添加名称：%@ desiredAccuracy = %f",anIAregion.alarm.alarmName,anIAregion.monitoringForRegionDesiredAccuracy);
    }
    
}

- (void)stopAllRegionsMonitoring{
    NSSet *regions = self.standardLocationManager.monitoredRegions;
    for (CLRegion *anRegion in regions) {
        [self.standardLocationManager stopMonitoringForRegion:anRegion];
    }
}

- (void)start{
    running = YES; 
    [self startAllRegionsMonitoring];
    NSLog(@"maximumRegionMonitoringDistance = %f",self.standardLocationManager.maximumRegionMonitoringDistance);
}

- (void)stop{
    running = NO;
    [self.standardLocationManager stopUpdatingLocation];
    [self stopAllRegionsMonitoring];
}




#pragma mark -
#pragma mark Notification

- (void) handle_applicationDidEnterBackground:(id) notification{
}

- (void)handle_applicationWillEnterForeground_DidFinishLaunching:(NSNotification*)notification {
	
	
}

- (void)handle_applicationDidBecomeActive:(NSNotification*)notification {
    if (running) 
        [self.standardLocationManager startUpdatingLocation]; //标准定位，前台需要它
}

- (void) handle_applicationWillResignActive:(id)notification{	
	[YCSystemStatus deviceStatusSingleInstance].lastLocation = nil;//免得下次使用了缓存
    [self.standardLocationManager stopUpdatingLocation];//有闹钟，仅仅停止标准定位（界面需要的）
    
    NSLog(@"前 count = %d",self.standardLocationManager.monitoredRegions.count);
    //清理一下，防止有多余的区域在监控中
    NSSet *monitoredRegions = self.standardLocationManager.monitoredRegions;
    NSDictionary *regionsIA = [IARegionsCenter regionCenterSingleInstance].regions;
    NSArray *regionsIAKeys = [regionsIA allKeys];
    for (CLRegion *anRegion in monitoredRegions) {
        if (NSNotFound == [regionsIAKeys indexOfObject:anRegion.identifier]) {
            [self.standardLocationManager stopMonitoringForRegion:anRegion];
        }
    }
    NSLog(@"后 count = %d",self.standardLocationManager.monitoredRegions.count);
    
}

- (void) handle_regionsDidChange:(NSNotification*)notification {
    NSLog(@"handle_regionsDidChange");
    
    if (!running) 
        return;
    
    IASaveInfo *saveInfo = [((NSNotification*)notification).userInfo objectForKey:IASaveInfoKey];
	if (saveInfo) {
        
        IARegion *theIARegion = [((NSNotification*)notification).userInfo objectForKey:IARegionKey];
        if (theIARegion == nil) return;
		
		if (IASaveTypeUpdate == saveInfo.saveType || IASaveTypeAdd == saveInfo.saveType) {
			if (theIARegion.alarm.enabled) {
                //替换或添加
                [self.standardLocationManager startMonitoringForRegion:theIARegion.region desiredAccuracy:theIARegion.monitoringForRegionDesiredAccuracy];
                NSLog(@"替换或添加名称：%@ desiredAccuracy = %f",theIARegion.alarm.alarmName,theIARegion.monitoringForRegionDesiredAccuracy);
            }else{
                //删除
                [self.standardLocationManager stopMonitoringForRegion:theIARegion.region];
                NSLog(@"禁用名称：%@ desiredAccuracy = %f",theIARegion.alarm.alarmName,theIARegion.monitoringForRegionDesiredAccuracy);
            }
            
 		}else if(IASaveTypeDelete == saveInfo.saveType){
			//删除
			[self.standardLocationManager stopMonitoringForRegion:theIARegion.region];
			NSLog(@"删除名称：%@ desiredAccuracy = %f",theIARegion.alarm.alarmName,theIARegion.monitoringForRegionDesiredAccuracy);
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
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    //////////////////////////////////////////////////////////////
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) > 5.0) {
		return;
	}
    
    [YCSystemStatus deviceStatusSingleInstance].lastLocation = newLocation;//收集last数据
    [self sendStandardLocationDidFinishNotificationWithLocation:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[YCSystemStatus deviceStatusSingleInstance].lastLocation = nil;
    [self sendStandardLocationDidFinishNotificationWithLocation:nil];
    
}



- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    IARegion *theIAregion = [[IARegionsCenter regionCenterSingleInstance].regions objectForKey:region.identifier];
    
    //if (theIAregion.userLocationType != IAUserLocationTypeInner) 
    {
        [self.delegate locationManager:self didEnterRegion:theIAregion];
        theIAregion.userLocationType = IAUserLocationTypeInner;
    }

}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    IARegion *theIAregion = [[IARegionsCenter regionCenterSingleInstance].regions objectForKey:region.identifier];
    
    //if (theIAregion.userLocationType != IAUserLocationTypeOuter) 
    {
        [self.delegate locationManager:self didExitRegion:theIAregion];
        theIAregion.userLocationType = IAUserLocationTypeOuter;

    }
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"monitoringDidFailForRegion");
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
