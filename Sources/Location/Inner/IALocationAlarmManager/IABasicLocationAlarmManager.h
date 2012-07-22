//
//  IARegionMonitoringLocationManager.h
//  iAlarm
//
//  Created by li shiyong on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IALocationAlarmManager.h"
#import "IALocationManagerDelegate.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class IALocationManager;

@interface IABasicLocationAlarmManager : IALocationAlarmManager <CLLocationManagerDelegate>{    
    IALocationManager *_locationManager;
}

@end
