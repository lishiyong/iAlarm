//
//  YCForwardGeocoder.h
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"
#import <Foundation/Foundation.h>

typedef enum YCForwardGeocoderType {
    YCForwardGeocoderTypeBS = 1,
    YCForwardGeocoderTypeApple,
} YCForwardGeocoderType;

@class CLRegion;

typedef void (^YCforwardGeocodeCompletionHandler)(NSArray *placemarks, NSError *error);

@interface YCForwardGeocoder : NSObject{

@package
    NSTimeInterval _timeout;
    
}

@property (nonatomic) NSTimeInterval timeout;
- (id)initWithTimeout:(NSTimeInterval)timeout forwardGeocoderType:(YCForwardGeocoderType)type;

@property (nonatomic, readonly, getter=isGeocoding) BOOL geocoding;
- (void)cancel;
- (void)forwardGeocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;
- (void)forwardGeocodeAddressString:(NSString *)addressString completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;
- (void)forwardGeocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;
- (void)forwardGeocodeAddressString:(NSString *)addressString inMapRect:(MKMapRect)mapRect completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;

@end
