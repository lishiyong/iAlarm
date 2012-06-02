//
//  NSError+YCGeocode.m
//  iAlarm
//
//  Created by li shiyong on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BSForwardGeocoder.h"
#import <CoreLocation/CoreLocation.h>
#import "NSError+YCGeocode.h"

/*
// Enum for geocoding status responses
enum {
	G_GEO_SUCCESS = 200,
	G_GEO_BAD_REQUEST = 400,
	G_GEO_SERVER_ERROR = 500,
	G_GEO_MISSING_QUERY = 601,
	G_GEO_UNKNOWN_ADDRESS = 602,
	G_GEO_UNAVAILABLE_ADDRESS = 603,
	G_GEO_UNKNOWN_DIRECTIONS = 604,
	G_GEO_BAD_KEY = 610,
	G_GEO_TOO_MANY_QUERIES = 620,
    G_GEO_NETWORK_ERROR = 900
};

typedef enum {
    kCLErrorLocationUnknown  = 0,
    kCLErrorDenied,
    kCLErrorNetwork,
    kCLErrorGeocodeFoundNoResult,
    kCLErrorGeocodeFoundPartialResult,
    kCLErrorGeocodeCanceled
} CLError;
 */


@implementation NSError (YCGeocode)

+ (id)errorWithBSForwardGeocodeStatus:(NSInteger)status{
    
    NSInteger code = 0;
    switch (status) {
        case G_GEO_UNKNOWN_ADDRESS:
        case G_GEO_UNAVAILABLE_ADDRESS:
            code = kCLErrorGeocodeFoundNoResult;
            break;
        case G_GEO_TOO_MANY_QUERIES:
            code = kCLErrorDenied;
            break;   
        case G_GEO_NETWORK_ERROR:
            code = kCLErrorNetwork;
            break;
        default:
            code = kCLErrorLocationUnknown;
            break;
    }
        
    return [NSError errorWithDomain:kCLErrorDomain code:code userInfo:nil];
}

@end
