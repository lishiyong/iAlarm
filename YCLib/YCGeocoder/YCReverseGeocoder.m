//
//  YCGeocoder.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlaceholderGeocoder.h"
#import "YCGeocoder.h"

NSString *YCGeocodeErrorDomain = @"YCGeocodeErrorDomain";

@implementation YCGeocoder
@synthesize geocoding, timeout = _timeout;

+ (id)allocWithZone:(NSZone *)zone{
    return [YCPlaceholderGeocoder allocWithZone:zone];
}

- (id)init{
    self = [self initWithTimeout:10];
    return self;
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    self = [super init];
    if (self) {
        _timeout = timeout;
    }
    return self;
}

- (void)cancel{
    
}

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(YCReverseGeocodeCompletionHandler)completionHandler{
    
}

@end
