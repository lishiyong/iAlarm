//
//  YCGeocoderAfter5.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"
#import "YCGeocoderAfter5.h"

@implementation YCGeocoderAfter5
@synthesize timeout = _timeout;

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    self = [super init];
    if (self) {
        _timeout = timeout;
        geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)dealloc{
    [geocoder release];
    [super dealloc];
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
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        if (!error) {
            YCPlacemark *placemark = [[YCPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
            completionHandler(placemark,error);
        }else{
            completionHandler(nil,error);
        }
    }];
}


@end
