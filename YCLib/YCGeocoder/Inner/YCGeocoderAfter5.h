//
//  YCGeocoderAfter5.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCGeocoder.h"
#import <CoreLocation/CoreLocation.h>

@interface YCGeocoderAfter5 : YCGeocoder{
    NSTimeInterval _timeout;
    CLGeocoder *geocoder;
}

@end
