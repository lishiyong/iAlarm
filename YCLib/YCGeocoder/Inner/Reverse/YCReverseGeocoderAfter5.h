//
//  YCGeocoderAfter5.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCReverseGeocoder.h"
#import <CoreLocation/CoreLocation.h>

@interface YCReverseGeocoderAfter5 : YCReverseGeocoder{
    CLGeocoder *_geocoder;
    CLGeocodeCompletionHandler _reverseGeocodeCompletionHandler;
}

@end
