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
    
    //用完就释放，不能依赖receiver中的dealloc，因为有可能与recever互为引用
    CLGeocodeCompletionHandler _reverseGeocodeCompletionHandler; 
}

@end
