//
//  YCPlacehoderGeocoder.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCDouble.h"
#import "YCReverseGeocoderBefore5.h"
#import "YCReverseGeocoderAfter5.h"
#import "YCPlaceholderReverseGeocoder.h"
#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>

@implementation YCPlaceholderReverseGeocoder


- (id)initWithTimeout:(NSTimeInterval)timeout{
    
    //5.0版本才支持 CLGeocoder 这个类
    double systeVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    NSComparisonResult result = YCCompareDouble(systeVersion, 5.0);
    
    id obj = nil;
    if (result == NSOrderedDescending || result == NSOrderedSame)  {
        obj = [[YCReverseGeocoderBefore5 alloc] initWithTimeout:timeout];
        //obj = [[YCGeocoderAfter5 alloc] initWithTimeout:timeout];
    }else{
        obj = [[YCReverseGeocoderBefore5 alloc] initWithTimeout:timeout];
    }
    
    return obj;

}

static YCPlaceholderReverseGeocoder *single = nil;
+ (id)allocWithZone:(NSZone *)zone
{
    if (single == nil) {
        single = NSAllocateObject([self class], 0, zone);
    }
    return single;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
 

@end
