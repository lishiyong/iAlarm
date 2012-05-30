//
//  YCPlacehoderGeocoder.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCGeocoderBefore5.h"
#import "YCGeocoderAfter5.h"
#import "YCPlacehoderGeocoder.h"
#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>

@implementation YCPlacehoderGeocoder

- (id)init{
    self = [self initWithTimeout:10];
    return self;
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    
    id obj = nil;
    if (NO) {
        obj = [[YCGeocoderAfter5 alloc] initWithTimeout:timeout];
    }else{
        obj = [[YCGeocoderBefore5 alloc] initWithTimeout:timeout];
    }
    
    return obj;

}

static YCPlacehoderGeocoder *single = nil;
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
