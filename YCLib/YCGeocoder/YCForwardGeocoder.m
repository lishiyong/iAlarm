//
//  YCForwardGeocoder.m
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlaceholderForwardGeocoder.h"
#import "YCForwardGeocoder.h"

@implementation YCForwardGeocoder
@synthesize timeout = _timeout;

+ (id)allocWithZone:(NSZone *)zone{
    return [YCPlaceholderForwardGeocoder allocWithZone:zone];
}

- (id)initWithTimeout:(NSTimeInterval)timeout forwardGeocoderType:(YCForwardGeocoderType)type{
    self = [super init];
    if (self) {
        _timeout = timeout;
    }
    return self;
}

- (BOOL)isGeocoding{return NO;};
- (void)cancel{}
- (void)forwardGeocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{}
- (void)forwardGeocodeAddressString:(NSString *)addressString completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{}
- (void)forwardGeocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{}
- (void)forwardGeocodeAddressString:(NSString *)addressString inMapRect:(MKMapRect)mapRect completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{}

@end
