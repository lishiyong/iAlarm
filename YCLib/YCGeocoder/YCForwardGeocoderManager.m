//
//  YCForwardGeocoderManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"
#import "NSValue+YC.h"
#import "YCForwardGeocoderManager.h"

@interface YCForwardGeocoderManager (private)

- (void)_prepare;
- (void)_forwardGeocode:(YCForwardGeocoder*)geocoder addressString:(NSString *)addressString viewportBiasing:(NSObject*)viewportBiasing;
- (void)_handleGeocodeCompletionWithError:(NSError*)error;

@end

@implementation YCForwardGeocoderManager

- (id)init{
    self = [super init];
    if (self) {
        _results = [[NSMutableSet set] retain];
        _geocoders = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)dealloc{
    [self _prepare];
    [_forwardGeocodeCompletionHandler release];
    [_results release];
    [_geocoders release];
    [_reservedViewportBiasings release];
    [_addressString release];
}

- (void)cancel{
    _canceled = YES;
    
    for (YCForwardGeocoder *anObj in _geocoders) {
        if ([(YCForwardGeocoder*) anObj isGeocoding])
            [(YCForwardGeocoder*) anObj cancel];
    }
    [_geocoders removeAllObjects];
}

- (void)_handleGeocodeCompletionWithError:(NSError*)error{
    NSLog(@"_geocoders.count = %d",_geocoders.count);
    
    if (_canceled) 
        return;
    
    if (_geocoders.count != 0) //还有的在查询
        return;
    
    NSLog(@"_geocoders.count = %d _results.count = %d",_geocoders.count,_results.count);
    
    if (_results.count > 0) {//有一个结果，就不返回错误
        _forwardGeocodeCompletionHandler(_results.allObjects,nil);
        //[_results removeAllObjects];
    }else if (_reservedViewportBiasings && _reservedViewportBiasings.count > 0){
        //无结果，用备用视口再查询一遍
        NSArray *viewports = [_reservedViewportBiasings retain];
        YCforwardGeocodeCompletionHandler blockHandler = [_forwardGeocodeCompletionHandler copy];
        NSString *addressString = [_addressString copy];
        
        [self forwardGeocodeAddressString:addressString viewportBiasings:viewports reservedViewportBiasings:nil completionHandler:blockHandler];
        
        [viewports release];
        [blockHandler release];
        [addressString release];
    }else{
        _forwardGeocodeCompletionHandler(nil,error);//返回最后一次的错误
    }
}

- (void)_forwardGeocode:(YCForwardGeocoder*)geocoder addressString:(NSString *)addressString viewportBiasing:(NSObject*)viewportBiasing
{
    
    YCforwardGeocodeCompletionHandler theBlock = ^(NSArray *placemarks, NSError *error){
        if (!error && placemarks.count >0 ) {
            //查询成功。YCPlacemark类覆写了isEqual:、hash,所以在set数据结构中不会有坐标重复的。            
            [_results addObjectsFromArray:placemarks];
        }
        [_geocoders removeObject:geocoder];
        [self _handleGeocodeCompletionWithError:error];
    };
    
    if ([viewportBiasing isKindOfClass:[CLRegion class]]){
        [geocoder forwardGeocodeAddressString:addressString inRegion:(CLRegion*)viewportBiasing completionHandler:theBlock];
    }else{
        MKMapRect mapRect = [(NSValue*)viewportBiasing mapRectValue];
        [geocoder forwardGeocodeAddressString:addressString inMapRect:mapRect completionHandler:theBlock];
    }
    
}

- (void)_prepare{
    //先都停止解析,再清空结果集
    [_geocoders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([(YCForwardGeocoder*) obj isGeocoding])
            [(YCForwardGeocoder*) obj cancel];
    }];
    [_geocoders removeAllObjects];
    
    [_results removeAllObjects];
    
    if (_forwardGeocodeCompletionHandler) {
        [_forwardGeocodeCompletionHandler release];
        _forwardGeocodeCompletionHandler = nil;
    }
    
    [_reservedViewportBiasings release];
    _reservedViewportBiasings = nil;
    
    [_addressString release];
    _addressString = nil;
    
    _canceled = NO;
}

- (void)forwardGeocodeAddressString:(NSString *)addressString viewportBiasings:(NSArray*)viewportBiasings reservedViewportBiasings:(NSArray*)reservedViewportBiasings  completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    [self _prepare];
    _forwardGeocodeCompletionHandler = [completionHandler copy];
    _reservedViewportBiasings = [reservedViewportBiasings retain];
    _addressString = [addressString retain];
    
    for (id anObj in viewportBiasings) {
        YCForwardGeocoder *geocoderA = [[[YCForwardGeocoder alloc] initWithTimeout:3.0 forwardGeocoderType:YCForwardGeocoderTypeApple] autorelease];
        YCForwardGeocoder *geocoderB = [[[YCForwardGeocoder alloc] initWithTimeout:20.0 forwardGeocoderType:YCForwardGeocoderTypeBS] autorelease];
        
        //
        [_geocoders addObject:geocoderA];
        [_geocoders addObject:geocoderB];
        
        
        [self _forwardGeocode:geocoderA addressString:addressString viewportBiasing:anObj];
        [self _forwardGeocode:geocoderB addressString:addressString viewportBiasing:anObj];
        
    }
    
}

- (NSString *)addressString;{
    return _addressString;
}

@end
