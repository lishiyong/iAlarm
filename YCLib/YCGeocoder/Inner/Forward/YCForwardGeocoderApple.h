//
//  YCForwardGeocoderApple.h
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "YCForwardGeocoder.h"

@interface YCForwardGeocoderApple : YCForwardGeocoder{
    CLGeocoder *_forwardGeocoder;
}

@end
