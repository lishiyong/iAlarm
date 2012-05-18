//
//  YCMapsUtility.h
//  iAlarm
//
//  Created by li shiyong on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YCMapsUtility : NSObject {

}

BOOL YCMKCoordinateSpanIsValid(MKCoordinateSpan span);
BOOL YCMKCoordinateRegionIsValid(MKCoordinateRegion region);
/*
//从地址信息提取地址字符串
+(NSString*)positionStringFromPlacemark:(MKPlacemark*)placemark;
+(NSString*)titleStringFromPlacemark:(MKPlacemark*)placemark;
+(NSString*)positionShortStringFromPlacemark:(MKPlacemark*)placemark;
 */

NSString* YCGetAddressString(MKPlacemark* placemark);
NSString* YCGetAddressShortString(MKPlacemark* placemark);
NSString* YCGetAddressTitleString(MKPlacemark* placemark);

//比较2个 MKCoordinateRegion；
//返回值:
BOOL YCCompareMKCoordinateRegion(MKCoordinateRegion src1,MKCoordinateRegion src2);



@end
