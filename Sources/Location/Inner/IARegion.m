//
//  IARegion.m
//  iAlarm
//
//  Created by li shiyong on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCParam.h"
#import "IANotifications.h"
#import "LocalizedString.h"
#import "YCPositionType.h"
#import "IAGlobal.h"
#import "IAAlarm.h"
#import "IARegion.h"

@implementation IARegion

@synthesize alarm;
@synthesize region;
@synthesize userLocationType;

- (CLLocationAccuracy)monitoringForRegionDesiredAccuracy{
    /*
    const CLLocationAccuracy kMaxDesiredAccuracy = 200.0;
	const CLLocationAccuracy kMinDesiredAccuracy = 20.0;
    
    CLLocationDistance radius = self.region.radius;
    CLLocationAccuracy desiredAccuracy = radius/10;
    desiredAccuracy = (desiredAccuracy > kMaxDesiredAccuracy) ? kMaxDesiredAccuracy : desiredAccuracy;
    desiredAccuracy = (desiredAccuracy < kMinDesiredAccuracy) ? kMinDesiredAccuracy : desiredAccuracy;
    return desiredAccuracy;
     */
    return kCLLocationAccuracyHundredMeters;
}

-(CLLocationDistance)radiusInnerForRadius:(CLLocationDistance)radius{
	//CLLocationDistance radiusInner = radius - 100.0; //内边缘
	CLLocationDistance radiusInner = radius; //内边缘
	return radiusInner;
}
-(CLLocationDistance)regionOuterForRadius:(CLLocationDistance)radius{
	//CLLocationDistance radiusOuter = radius + 200.0; //外边缘
	
	const CLLocationDistance kMaxOffset = 500.0;
	const CLLocationDistance kMinOffset = 200.0;
	CLLocationDistance offset = radius * 0.1;
	offset = (offset > kMaxOffset) ? kMaxOffset : offset;
	offset = (offset < kMinOffset) ? kMinOffset : offset;
	CLLocationDistance radiusOuter = radius + offset; //外边缘
	return radiusOuter;
}

- (CLRegion*)regionInner{
	if (regionInner == nil) {
		CLLocationDistance radiusInner = [self radiusInnerForRadius:self.region.radius];
		regionInner = [[CLRegion alloc] 
						initCircularRegionWithCenter:self.region.center radius:radiusInner identifier:@"regionInner"] ;
	}
	return regionInner;
}

- (CLRegion*)regionOuter{
	if (regionOuter == nil) {
		CLLocationDistance radiusOuter = [self regionOuterForRadius:self.region.radius];
		regionOuter = [[CLRegion alloc] 
						initCircularRegionWithCenter:self.region.center radius:radiusOuter identifier:@"regionOuter"] ;
	}
	return regionOuter;
}

- (CLRegion*)preAlarmRegion{
	if (preAlarmRegion == nil) {
		CLLocationDistance radius = self.region.radius + kPreAlarmDistance; //预警范围是＋x000米;
		preAlarmRegion = [[CLRegion alloc] 
					   initCircularRegionWithCenter:self.region.center radius:radius identifier:@"preAlarmRegion"];
	}
	return preAlarmRegion;
}

- (CLRegion*)bigPreAlarmRegion{
	if (bigPreAlarmRegion == nil) {
		CLLocationDistance radius = self.region.radius + kBigPreAlarmDistance; //大预警范围是＋x000米;
		bigPreAlarmRegion = [[CLRegion alloc] 
						  initCircularRegionWithCenter:self.region.center radius:radius identifier:@"bigPreAlarmRegion"];
	}
	return bigPreAlarmRegion;
}

- (id)location{
	if (location == nil) {
		location = [[CLLocation alloc] initWithLatitude:alarm.coordinate.latitude longitude:alarm.coordinate.longitude];
	}
	return location;
}

- (IAUserLocationType)containsCoordinate:(CLLocationCoordinate2D)coodinate{
		
	BOOL isInner = [self.regionInner containsCoordinate:coodinate];
	BOOL isOuter = ![self.regionOuter containsCoordinate:coodinate];
	if (isInner) {
		return IAUserLocationTypeInner;
	}else if (isOuter){
		return IAUserLocationTypeOuter;	
	}else {
		return IAUserLocationTypeEdge;	
	}

}

- (CLLocationDistance)distanceFromLocation:(const CLLocation *)theLocation{
	CLLocationDistance d = 0.0;
	if (theLocation) 
		d = [theLocation distanceFromLocation:self.location];
	return d;
}


- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    if ([YCParam paramSingleInstance].regionMonitoring) { //区域监控
        CLLocation *currentLocation = [[notification userInfo] objectForKey:IAStandardLocationKey];
        if (currentLocation){
            
            IAUserLocationType anType = [self containsCoordinate:currentLocation.coordinate];
            if (self.userLocationType != anType) 
                self.userLocationType = [self containsCoordinate:currentLocation.coordinate];
            
        }
    }
}
 

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
	//if (object == self && [keyPath isEqualToString:@"userLocationType"])
	{				
		//发通知
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IARegionTypeDidChangeNotification 
																	  object:self
																	userInfo:[NSDictionary dictionaryWithObject:self forKey:IAChangedRegionKey]];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
		
	}
	
}

- (void)registerNotifications {
	[self addObserver:self forKeyPath:@"userLocationType" options:NSKeyValueObservingOptionNew context:nil];
    [self.alarm addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	//有新的定位数据产生
	[notificationCenter addObserver: self
						   selector: @selector (handle_standardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
     
}

- (void)unRegisterNotifications{
	[self removeObserver:self forKeyPath:@"userLocationType"];
    [self.alarm removeObserver:self forKeyPath:@"enabled"];
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
     
}


- (id)initWithAlarm:(IAAlarm*)theAlarm currentLocation:(CLLocation*)currentLocation{
	self = [super init];
    if (self) {
		alarm = [theAlarm retain];
		region = [[CLRegion alloc] 
				  initCircularRegionWithCenter:theAlarm.coordinate radius:theAlarm.radius identifier:theAlarm.alarmId];

        if ([YCParam paramSingleInstance].regionMonitoring) { //iphone 4
            if ([alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //是 “到达时候”提醒
                userLocationType = IAUserLocationTypeOuter; //默认在区域外
            }else {
                userLocationType = IAUserLocationTypeInner; 
            }
        }else{
            //currentLocation= nil; //Test
            if (currentLocation){
                userLocationType = [self containsCoordinate:currentLocation.coordinate];
                
                //如果是边缘，则当作默认情况
                if (IAUserLocationTypeEdge == userLocationType) {
                    if ([alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //是 “到达时候”提醒
                        userLocationType = IAUserLocationTypeInner; //默认在区域内
                    }else {
                        userLocationType = IAUserLocationTypeOuter; 
                    }
                }
                
            }else{
                
                if ([alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //是 “到达时候”提醒
                    userLocationType = IAUserLocationTypeInner; //默认在区域内 
                    //userLocationType = IAUserLocationTypeOuter;
                }else {
                    userLocationType = IAUserLocationTypeOuter; 
                }
                
            }
        }
		
        
        [self registerNotifications];
		 
	}
	return self;
}

- (BOOL)isDetecting{
    if (self.alarm.enabled){
        if ([self.alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //到达时候提醒
            if (IAUserLocationTypeOuter == self.userLocationType) {
                return YES;
            }else{
                return NO;
            }
        }else{//离开时候提醒
            if (IAUserLocationTypeInner == self.userLocationType) {
                return YES;
            }else{
                return NO;
            }
        }
    }else
        return NO;
}

- (void)dealloc {
    [self unRegisterNotifications];
	[alarm release];
	[region release];
	[regionInner release];
	[regionOuter release];
	[preAlarmRegion release];
	[bigPreAlarmRegion release];
	[location release];
    [super dealloc];
}

@end
