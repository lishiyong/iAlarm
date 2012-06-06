//
//  YCForwardGeocoderBS.m
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCMaps.h"
#import <AddressBookUI/AddressBookUI.h>
#import "NSObject+YC.h"
#import "YCPlacemark+YCForwardGeocode.h"
#import "NSError+YCForwardGeocode.h"
#import "YCForwardGeocoderBS.h"

@implementation YCForwardGeocoderBS

#pragma mark - Init and dealloc

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithTimeout:(NSTimeInterval)timeout forwardGeocoderType:(YCForwardGeocoderType)type{
    self = [super initWithTimeout:timeout forwardGeocoderType:type];
    if (self) {
        _forwardGeocoder = [[BSForwardGeocoder alloc] init];
        _forwardGeocoder.timeoutInterval = timeout +1;
        _forwardGeocoder.useHTTP = YES;
        _geocoding = NO;
    }
    return self;
}

- (void)dealloc{
    [_forwardGeocoder cancel];[_forwardGeocoder release];
    [_forwardGeocodeCompletionHandler release];
    [super dealloc];
}

#pragma mark - Implement Abstract Super Method

- (BOOL)isGeocoding{
    return _geocoding;
};

- (void)cancel{
    NSLog(@"cancel");
    if (_forwardGeocoder.geocoding) 
        [_forwardGeocoder cancel];
}

- (void)forwardGeocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    NSString *addressString = ABCreateStringWithAddressDictionary(addressDictionary,NO);
    [self forwardGeocodeAddressString:addressString inMapRect:MKMapRectNull completionHandler:completionHandler];
}

- (void)forwardGeocodeAddressString:(NSString *)addressString completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    [self forwardGeocodeAddressString:addressString inMapRect:MKMapRectNull completionHandler:completionHandler];
}

- (void)forwardGeocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{

    MKMapRect mapRect = YCMapRectForRegion(region);
    [self forwardGeocodeAddressString:addressString inMapRect:mapRect completionHandler:completionHandler];
}

- (void)forwardGeocodeAddressString:(NSString *)addressString inMapRect:(MKMapRect)mapRect completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    //超时处理
    [self performBlock:^{
        if (_forwardGeocoder.geocoding) {
            [_forwardGeocoder cancel];
            completionHandler(nil,[NSError errorWithDomain:kCLErrorDomain code:kCLErrorGeocodeCanceled userInfo:nil]); 
        }
    } afterDelay:_timeout];
    
    [_forwardGeocoder forwardGeocodeWithQuery:addressString regionBiasing:nil viewportBiasing:mapRect 
                                      success: ^(NSArray *results)
     {
         //查询成功，BS结果集转换成YC结果
         NSArray *ycPlacemarks = [YCPlacemark placemarksWithBSKmlResults:results];
         completionHandler(ycPlacemarks,nil);   
     } 
                                      failure:^(int status, NSString *errorMessage)
     {
         completionHandler(nil,[NSError errorWithBSForwardGeocodeStatus:status]);                              
     }];
    
}


@end
