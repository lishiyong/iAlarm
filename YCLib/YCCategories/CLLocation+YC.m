//
//  CLLocation+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CLLocation+YC.h"

@implementation CLLocation (YC)

- (CLLocationDistance)distanceFromCoordinate:(const CLLocationCoordinate2D)coordinate{
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:self.altitude horizontalAccuracy:self.horizontalAccuracy verticalAccuracy:self.verticalAccuracy timestamp:[NSDate date]];
    CLLocationDistance d = [self distanceFromLocation:location];
    
    [location release];
    return d;
}


- (NSString*)distanceStringFromCoordinate:(const CLLocationCoordinate2D)coordinate withFormat1:(NSString*)formate1 withFormat2:(NSString*)formate2 {
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:self.altitude horizontalAccuracy:self.horizontalAccuracy verticalAccuracy:self.verticalAccuracy timestamp:[NSDate date]];
    NSString *s = [self distanceStringFromLocation:location withFormat1:formate1 withFormat2:formate2];
    
    [location autorelease];
    return s;
}

- (NSString*)distanceStringFromLocation:(const CLLocation*)location withFormat1:(NSString*)formate1 withFormat2:(NSString*)formate2 {
    
    CLLocationDistance distance = [location distanceFromLocation:self];
    
    NSString *s = nil;
    if (distance > 100.0) 
        s = [NSString stringWithFormat:formate1,distance/1000.0];
    else
        s = [NSString stringWithFormat:formate2,distance/1000.0];;
    
    return s;
}


@end
