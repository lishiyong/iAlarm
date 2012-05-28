//
//  YCGeocoder.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacehoderGeocoder.h"
#import "YCGeocoder.h"

@implementation YCGeocoder
@synthesize geocoding, timeout;

+ (id)allocWithZone:(NSZone *)zone{
    //return [YCPlacehoderGeocoder sharedInstance];
    return [YCPlacehoderGeocoder allocWithZone:zone];
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    return nil; //永远也不会到这里
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
