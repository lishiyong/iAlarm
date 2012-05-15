//
//  YCLocation.h
//  TestMapOffset
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 把“正常坐标”转换成“火星坐标”
 **/
CLLocationCoordinate2D convertCoordinateToMarsCoordinate(CLLocationCoordinate2D coordinate);

/**
 把“火星坐标”转换成“正常坐标”
 **/
CLLocationCoordinate2D convertMarsCoordinateToCoordinate(CLLocationCoordinate2D marsCoordinate);