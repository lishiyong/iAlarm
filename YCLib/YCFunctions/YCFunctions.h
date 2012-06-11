//
//  YCGFunctions.h
//  iAlarm
//
//  Created by li shiyong on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//产生一个唯一的序列号
NSString* YCSerialCode();

NSString* YCStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord);

/**
 默认逗号 北纬 85°59′59″,东经 180°59′59″
 **/
NSString* YCLocalizedStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord, NSString *northLatitude, NSString *southLatitude, NSString *easeLongitude, NSString *westLongitude);

/**
 separater：中间分隔的符号
 **/
NSString* YCLocalizedStringFromCLLocationCoordinate2DUsingSeparater(CLLocationCoordinate2D coord, NSString *northLatitude, NSString *southLatitude, NSString *easeLongitude, NSString *westLongitude, NSString *separater);

//比较2个 CGPoint；
BOOL YCCGPointEqualPoint(CGPoint src1,CGPoint src2);

//比较2个 CGPoint。有允许误差；
BOOL YCCGPointEqualPointWithOffSet(CGPoint src1,CGPoint src2,NSUInteger offSet);



