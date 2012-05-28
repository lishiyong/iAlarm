//
//  YCMapsUtility.h
//  iAlarm
//
//  Created by li shiyong on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


BOOL YCMKCoordinateRegionIsValid(MKCoordinateRegion region);

//比较数据类型；
BOOL YCMKCoordinateSpanEqualToSpan(MKCoordinateSpan src1,MKCoordinateSpan src2);
BOOL YCMKCoordinateRegionEqualToRegion(MKCoordinateRegion src1,MKCoordinateRegion src2);

NSString* YCGetAddressString(MKPlacemark* placemark);
NSString* YCGetAddressShortString(MKPlacemark* placemark);
NSString* YCGetAddressTitleString(MKPlacemark* placemark);

