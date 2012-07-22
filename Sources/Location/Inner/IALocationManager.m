//
//  IALocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IALocationManager.h"

@implementation IALocationManager

@synthesize updatingLocation = _updatingLocation, monitoringSignificantLocationChanges = _monitoringSignificantLocationChanges, monitoringForRegion = _monitoringForRegion;

#pragma mark - Standard Location Updates

- (void)startUpdatingLocation{
    _updatingLocation = YES;
    [super startUpdatingLocation];
}

- (void)stopUpdatingLocation{
    _updatingLocation = NO;
    [super stopUpdatingLocation];
}

#pragma mark - Significant Location Updates

- (void)startMonitoringSignificantLocationChanges{
    _monitoringSignificantLocationChanges = YES;
    [super startMonitoringSignificantLocationChanges];
}

- (void)stopMonitoringSignificantLocationChanges{
    _monitoringSignificantLocationChanges = NO;
    [super stopMonitoringSignificantLocationChanges];
}

#pragma mark - Region Monitoring

- (void)startMonitoringForRegion:(CLRegion *)region{
    _monitoringForRegion = YES;
    [super startMonitoringForRegion:region];
}

- (void)startMonitoringForRegion:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy{
    _monitoringForRegion = YES;
    [super startMonitoringForRegion:region desiredAccuracy:accuracy];
}

- (void)stopMonitoringForRegion:(CLRegion *)region{
    _monitoringForRegion = NO;
    [super stopMonitoringForRegion:region];
}

@end
