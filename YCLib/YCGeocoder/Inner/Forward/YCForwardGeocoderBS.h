//
//  YCForwardGeocoderBS.h
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BSForwardGeocoder.h"
#import "YCForwardGeocoder.h"

@interface YCForwardGeocoderBS : YCForwardGeocoder{
    BSForwardGeocoder *_forwardGeocoder;
    YCforwardGeocodeCompletionHandler _forwardGeocodeCompletionHandler;
    BOOL _geocoding;
}

@end
