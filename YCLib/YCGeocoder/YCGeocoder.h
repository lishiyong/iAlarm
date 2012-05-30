//
//  YCGeocoder.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@class CLLocation, CLRegion;
@class YCPlacemark;

typedef void (^YCGeocodeCompletionHandler)(NSArray *placemark, NSError *error);
typedef void (^YCReverseGeocodeCompletionHandler)(YCPlacemark *placemark, NSError *error);

@interface YCGeocoder : NSObject{
@package
    NSTimeInterval _timeout;
}

- (id)initWithTimeout:(NSTimeInterval)timeout;

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString completionHandler:(YCGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCGeocodeCompletionHandler)completionHandler;
- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(YCReverseGeocodeCompletionHandler)completionHandler;
    
@property (nonatomic, readonly, getter=isGeocoding) BOOL geocoding;
@property (nonatomic) NSTimeInterval timeout;
- (void)cancel;



@end
