//
//  YCGeocoderBefore5.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"
#import "YCReverseGeocoderBefore5.h"

@interface YCReverseGeocoderBefore5 (private) 

/**
 用超时错误回调
 **/
- (void)_doFailReverseGeocodeWithTimeoutError;

/**
 结束查询，并释放相关资源
 **/
- (void)_releaseResoure;

@end

@implementation YCReverseGeocoderBefore5

#pragma mark - Init and dealloc

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    self = [super initWithTimeout:timeout];
    if (self) {
    }
    return self;
}

- (void)dealloc{
    if (_resverseGeocoder.querying)
        [_resverseGeocoder cancel];
    [_resverseGeocoder release];
    
    [_reverseGeocodeCompletionHandler release];
    [super dealloc];
}

#pragma mark - Implement Abstract Super Method

- (void)cancel{
    if (_resverseGeocoder.querying) {
        [_resverseGeocoder cancel];
        [_resverseGeocoder.delegate reverseGeocoder:_resverseGeocoder didFailWithError:[NSError errorWithDomain:NSOSStatusErrorDomain code:-101 userInfo:nil] ];
    }
}

- (BOOL)isGeocoding{
    if (_resverseGeocoder) 
        return _resverseGeocoder.querying;
    else
        return NO;
}


- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(YCReverseGeocodeCompletionHandler)completionHandler{
    
    if (_resverseGeocoder.querying) return;
        
    _reverseGeocodeCompletionHandler = [completionHandler copy] ;
    _resverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
    _resverseGeocoder.delegate = self;
    [_resverseGeocoder start];
    [self performSelector:@selector(_doFailReverseGeocodeWithTimeoutError) withObject:nil afterDelay:_timeout]; //
    
}

#pragma mark - MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    if (_reverseGeocodeCompletionHandler) {
        YCPlacemark *ycplacemark = [[[YCPlacemark alloc] initWithPlacemark:placemark] autorelease];
        _reverseGeocodeCompletionHandler(ycplacemark,nil);
    }
    
    [self _releaseResoure];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_doFailReverseGeocodeWithTimeoutError) object:nil];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    if (_reverseGeocodeCompletionHandler) 
        _reverseGeocodeCompletionHandler(nil,error);
    [self _releaseResoure];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_doFailReverseGeocodeWithTimeoutError) object:nil];
}

#pragma mark - 工具

- (void)_doFailReverseGeocodeWithTimeoutError{
    if (_resverseGeocoder.querying) {
        [_resverseGeocoder cancel];
        [_resverseGeocoder.delegate reverseGeocoder:_resverseGeocoder didFailWithError:[NSError errorWithDomain:NSOSStatusErrorDomain code:-100 userInfo:nil] ];
    }
}

- (void)_releaseResoure{
    if (_resverseGeocoder) {
        [_resverseGeocoder release];
        _resverseGeocoder = nil;
    }

    if (_reverseGeocodeCompletionHandler) {
        [_reverseGeocodeCompletionHandler release];
        _reverseGeocodeCompletionHandler = nil;
    }
    
}

@end
