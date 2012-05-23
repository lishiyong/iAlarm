//
//  YCLocationUtility.m
//  iAlarm
//
//  Created by li shiyong on 11-1-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCDouble.h"
#import "YCLocation.h"

//默认显示地图的范围
const  CLLocationDistance kDefaultLatitudinalMeters  = 2500.0;
const  CLLocationDistance kDefaultLongitudinalMeters = 2500.0;
//缺省坐标－apple公司总部坐标
const CLLocationCoordinate2D kYCDefaultCoordinate = {37.331689, -122.030731};

BOOL YCCLLocationCoordinate2DEqualToCoordinateWithAccuracy(CLLocationCoordinate2D src1,CLLocationCoordinate2D src2,NSUInteger accuracy){
	BOOL retVal = NO;
	if (NSOrderedSame == YCCompareDoubleWithAccuracy(src1.latitude,src2.latitude,accuracy)) {
		if (NSOrderedSame == YCCompareDoubleWithAccuracy(src1.longitude,src2.longitude,accuracy)) {
			retVal = YES;
		}
	}
	return retVal;
}

BOOL YCCLLocationCoordinate2DEqualToCoordinate(CLLocationCoordinate2D src1,CLLocationCoordinate2D src2){
	return YCCLLocationCoordinate2DEqualToCoordinateWithAccuracy(src1,src2,6);
}

CLLocationDistance distanceBetweenCoordinates(CLLocationCoordinate2D aCoordinate,CLLocationCoordinate2D anotherCoordinate){
    CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:aCoordinate.latitude longitude:aCoordinate.longitude] autorelease];
    CLLocation *anotherLocation = [[[CLLocation alloc] initWithLatitude:anotherCoordinate.latitude longitude:anotherCoordinate.longitude] autorelease];
    
    return [aLocation distanceFromLocation:anotherLocation];
}

