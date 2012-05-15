//
//  YCMKLocationManager.h
//  iAlarm
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YCLocationManager : NSObject

+ (YCLocationManager*)sharedLocationManager;

/**
 是否转换中国境内的坐标
 **/
- (BOOL)chinaShiftEnabled;

/**
 坐标是否在中国境内
 **/
- (BOOL)isInChinaWithCoordinate:(CLLocationCoordinate2D) coordinate;

/**
 把“正常坐标”转换成“火星坐标”
 **/
- (CLLocationCoordinate2D)convertToMarsCoordinateFromCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 把“火星坐标”转换成“正常坐标”
 **/
- (CLLocationCoordinate2D)convertToCoordinateFromMarsCoordinate:(CLLocationCoordinate2D)marsCoordinate;


@end
