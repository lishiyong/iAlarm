//
//  IALocationManager.h
//  iAlarm
//
//  Created by li shiyong on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface IALocationManager : CLLocationManager{
    BOOL _updatingLocation;
    BOOL _monitoringSignificantLocationChanges;
    BOOL _monitoringForRegion;
}

@property (nonatomic, readonly) BOOL updatingLocation;
@property (nonatomic, readonly) BOOL monitoringSignificantLocationChanges;
@property (nonatomic, readonly) BOOL monitoringForRegion;

@end
