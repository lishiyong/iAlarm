//
//  YCForwardGeocoderApple.m
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark+YCForwardGeocode.h"
#import "NSObject+YC.h"
#import "YCForwardGeocoderApple.h"

@interface YCForwardGeocoderApple (private) 

//
- (void)_forwardGeocodeAddressString:(id)queryObj inRegion:(CLRegion *)region completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;

@end

@implementation YCForwardGeocoderApple

#pragma mark - Init and dealloc

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithTimeout:(NSTimeInterval)timeout forwardGeocoderType:(YCForwardGeocoderType)type{
    self = [super initWithTimeout:timeout forwardGeocoderType:type];
    if (self) {
        _forwardGeocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_forwardGeocoder cancelGeocode];[_forwardGeocoder release];
    [_forwardGeocodeCompletionHandler release];
    [super dealloc];
}

#pragma mark - Implement Abstract Super Method

- (BOOL)isGeocoding{
    return [_forwardGeocoder isGeocoding];
};

- (void)cancel{
    if (_forwardGeocoder.geocoding) 
        [_forwardGeocoder cancelGeocode];
}

- (void)forwardGeocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{

    [self _forwardGeocodeAddressString:addressDictionary inRegion:nil completionHandler:completionHandler];
}

- (void)forwardGeocodeAddressString:(NSString *)addressString completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{

    [self _forwardGeocodeAddressString:addressString inRegion:nil completionHandler:completionHandler];
}

- (void)forwardGeocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    [self _forwardGeocodeAddressString:addressString inRegion:region completionHandler:completionHandler];
}

- (void)forwardGeocodeAddressString:(NSString *)addressString inMapRect:(MKMapRect)mapRect completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    CLLocationCoordinate2D coordinate = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationDistance radius = mapRect.size.height/2; //墨卡托投影:地图点高度等于实际距离
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coordinate radius:radius identifier:@"regionForGeocode"];
    
    [self _forwardGeocodeAddressString:addressString inRegion:region completionHandler:completionHandler];
}

- (void)_forwardGeocodeAddressString:(id)queryObj inRegion:(CLRegion *)region completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    YCforwardGeocodeCompletionHandler theBlock = ^(NSArray *placemarks, NSError *error){
        if (!error) {
            //查询成功，CL结果集转换成YC结果
            NSArray *ycPlacemarks = [YCPlacemark placemarksWithCLPacemarks:placemarks];
            completionHandler(ycPlacemarks,nil);  
        }else{
            completionHandler(nil,error);   
        }
    };
    
    //超时处理
    [self performBlock:^{
        if (_forwardGeocoder.geocoding) {
            [_forwardGeocoder cancelGeocode];
            completionHandler(nil,[NSError errorWithDomain:kCLErrorDomain code:kCLErrorGeocodeCanceled userInfo:nil]); 
        }
    } afterDelay:_timeout];
    
    if ([queryObj isKindOfClass:[NSString class]]) {
        
        if (region) 
            [_forwardGeocoder geocodeAddressString:queryObj inRegion:region completionHandler:theBlock];
        else
            [_forwardGeocoder geocodeAddressString:queryObj completionHandler:theBlock];
        
    }else{
        [_forwardGeocoder geocodeAddressString:queryObj completionHandler:theBlock]; 
    }
 
}


@end
