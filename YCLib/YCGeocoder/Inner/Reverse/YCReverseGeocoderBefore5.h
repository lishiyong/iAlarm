//
//  YCGeocoderBefore5.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Mapkit/Mapkit.h>
#import "YCReverseGeocoder.h"

@interface YCReverseGeocoderBefore5 : YCReverseGeocoder<MKReverseGeocoderDelegate>{
    MKReverseGeocoder *_resverseGeocoder;
    YCReverseGeocodeCompletionHandler _reverseGeocodeCompletionHandler;
}

@end
