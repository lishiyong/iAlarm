//
//  CLLocation+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (YC)

/**
 假定坐标的海拔与接收者相同
 **/
- (CLLocationDistance)distanceFromCoordinate:(const CLLocationCoordinate2D)coordinate;

/**
 假定坐标的海拔与接收者相同
 **/
- (NSString*)distanceStringFromCoordinate:(const CLLocationCoordinate2D)coordinate withFormat1:(NSString*)formate1 withFormat2:(NSString*)formate2 ;

- (NSString*)distanceStringFromLocation:(const CLLocation*)location withFormat1:(NSString*)formate1 withFormat2:(NSString*)formate2;



@end
