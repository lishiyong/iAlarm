//
//  YCGeocoderBefore5.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BSForwardGeocoder.h"
#import <Mapkit/Mapkit.h>
#import "YCGeocoder.h"

@interface YCGeocoderBefore5 : YCGeocoder<MKReverseGeocoderDelegate>{
    BSForwardGeocoder *_forwardGeocoder;
    MKReverseGeocoder *_resverseGeocoder;
    YCReverseGeocodeCompletionHandler _reverseGeocodeCompletionHandler;
}

@end
