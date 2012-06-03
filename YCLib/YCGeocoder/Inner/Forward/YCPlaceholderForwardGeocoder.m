//
//  YCPlaceholderForwardGeocoder.m
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCForwardGeocoderBS.h"
#import "YCForwardGeocoderApple.h"
#import "YCPlaceholderForwardGeocoder.h"

@implementation YCPlaceholderForwardGeocoder

- (id)init{
    self = [self initWithTimeout:10 forwardGeocoderType:YCForwardGeocoderTypeBS]; //默认使用BS
    return self;
}

- (id)initWithTimeout:(NSTimeInterval)timeout forwardGeocoderType:(YCForwardGeocoderType)type{
        
    id obj = nil;
    switch (type) {
        case YCForwardGeocoderTypeBS:
            obj = [[YCForwardGeocoderBS alloc] initWithTimeout:timeout forwardGeocoderType:type];
            break;
        case YCForwardGeocoderTypeApple:
            obj = [[YCForwardGeocoderApple alloc] initWithTimeout:timeout forwardGeocoderType:type];
            break;    
        default:
            obj = [[YCForwardGeocoderBS alloc] initWithTimeout:timeout forwardGeocoderType:type];
            break;
    }
    
    return obj;
    
}

static YCPlaceholderForwardGeocoder *single = nil;
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
