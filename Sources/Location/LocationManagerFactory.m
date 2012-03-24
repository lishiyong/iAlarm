//
//  LocationManagerFactory.m
//  iAlarm
//
//  Created by li shiyong on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCParam.h"
#import "IABasicLocationManager.h"
#import "IARegionMonitoringLocationManager.h"
#import "IALocationManager.h"
#import "LocationManagerFactory.h"

@implementation LocationManagerFactory

+ (id<IALocationManagerInterface>)locationManagerInstanceWithDelegate:(id)delegate{
    id<IALocationManagerInterface> locationManager = nil;
    if ([YCParam paramSingleInstance].regionMonitoring) 
        locationManager = [[IARegionMonitoringLocationManager alloc] init]; //使用区域监控的定位
    else
    //locationManager = [[IALocationManager alloc] init];
        locationManager = [[IABasicLocationManager alloc] init];
        
    locationManager.delegate =delegate;
	
	return locationManager;
}

@end
