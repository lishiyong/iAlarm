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

@interface IARegion (private)

-(CLLocationDistance)radiusInner;//内边缘
-(CLLocationDistance)radiusOuter;//外边缘
- (id)initWithAlarm:(IAAlarm*)theAlarm;

@end

@implementation IARegion

@synthesize userLocationType = _userLocationType, alarm = _alarm;

- (void)setUserLocationType:(IAUserLocationType)userLocationType{
    _userLocationType = userLocationType;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self forKey:IAChangedRegionKey];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IARegionTypeDidChangeNotification 
                                                                  object:self 
                                                                userInfo:userInfo];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
}


-(CLLocationDistance)radiusInner{
	CLLocationDistance radiusInner = _region.radius; 
	return radiusInner;
}

-(CLLocationDistance)radiusOuter{
    CLLocationDistance radius = _region.radius;  
	
	const CLLocationDistance kMaxOffset = 500.0;
	const CLLocationDistance kMinOffset = 1.0;
	CLLocationDistance offset = radius * 0.1;
	offset = (offset > kMaxOffset) ? kMaxOffset : offset;
	offset = (offset < kMinOffset) ? kMinOffset : offset;
	CLLocationDistance radiusOuter = radius + offset; 
	return radiusOuter;
}

- (IAUserLocationType)containsCoordinate:(CLLocationCoordinate2D)coodinate{
		
	BOOL isInner = [_regionInner containsCoordinate:coodinate];
	BOOL isOuter = ![_regionOuter containsCoordinate:coodinate];
	if (isInner) {
		return IAUserLocationTypeInner;
	}else if (isOuter){
		return IAUserLocationTypeOuter;	
	}else {
		return IAUserLocationTypeEdge;	
	}
}

- (BOOL)isMonitoring{
    if ([self.alarm.positionType.positionTypeId isEqualToString:@"p002"]) {
        if (IAUserLocationTypeOuter == self.userLocationType) 
            return YES;
    }else {
        if (IAUserLocationTypeInner == self.userLocationType) 
            return YES;
    }
    
    return NO;
}

- (id)initWithAlarm:(IAAlarm*)theAlarm{
    self = [super init];
    if (self) {
        _alarm = [theAlarm retain];
        _region = [[CLRegion alloc] 
                   initCircularRegionWithCenter:theAlarm.realCoordinate radius:theAlarm.radius identifier:theAlarm.alarmId];
        
        _regionInner = [[CLRegion alloc] 
						initCircularRegionWithCenter:_region.center radius:self.radiusInner identifier:@"regionInner"];
        _regionOuter = [[CLRegion alloc] 
						initCircularRegionWithCenter:_region.center radius:self.radiusOuter identifier:@"regionOuter"];
        CLLocationDistance preAlarmRadius = _region.radius + kPreAlarmDistance; //预警范围是＋x000米;
		_preAlarmRegion = [[CLRegion alloc] 
                           initCircularRegionWithCenter:_region.center radius:preAlarmRadius identifier:@"preAlarmRegion"];
        CLLocationDistance bigPreAlarmRadius = _region.radius + kBigPreAlarmDistance; //大预警范围是＋x000米;
		_bigPreAlarmRegion = [[CLRegion alloc] 
                              initCircularRegionWithCenter:_region.center radius:bigPreAlarmRadius identifier:@"bigPreAlarmRegion"];
        
    }
    return self;
}

- (id)initWithAlarm:(IAAlarm*)theAlarm userLocationType:(IAUserLocationType)userLocationType{
    self = [self initWithAlarm:theAlarm];
    if (self) {
        _userLocationType = userLocationType;
    }
    return self;
}

- (id)initWithAlarm:(IAAlarm*)theAlarm currentLocation:(CLLocation*)currentLocation{
    self = [self initWithAlarm:theAlarm];
    if (self) {
        if (currentLocation){
            _userLocationType = [self containsCoordinate:currentLocation.coordinate];
            
            //如果是边缘，则当作默认情况
            if (IAUserLocationTypeEdge == _userLocationType) {
                if ([_alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //是 “到达时候”提醒
                    _userLocationType = IAUserLocationTypeInner; //默认在区域内
                }else {
                    _userLocationType = IAUserLocationTypeOuter; 
                }
            }
            
        }else{
            
            if ([_alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //是 “到达时候”提醒
                _userLocationType = IAUserLocationTypeInner; //默认在区域内 
            }else {
                _userLocationType = IAUserLocationTypeOuter; 
            }
            
        }
    }
    
	return self;
}


- (void)dealloc {
	[_alarm release];
	[_region release];
	[_regionInner release];
	[_regionOuter release];
	[_preAlarmRegion release];
	[_bigPreAlarmRegion release];
    [super dealloc];
}

@end
