//
//  YCGeocoder.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *YCGeocodeErrorDomain ;

// 错误编号
enum YCGeocodeErrorCode {
    YCGeocodeErrorUnknown = 1,
    YCGeocodeErrorServerFailure,
    YCGeocodeErrorNetworkError,
    YCGeocodeErrorUnKnownAddress,
    YCGeocodeErrorUnAvailableAddress,
    YCGeocodeErrorTooManyQueries,
};

@class CLLocation;
@class YCPlacemark;

typedef void (^YCReverseGeocodeCompletionHandler)(YCPlacemark *placemark, NSError *error);

@interface YCReverseGeocoder : NSObject{
@package
    NSTimeInterval _timeout;
}
@property (nonatomic) NSTimeInterval timeout;
- (id)initWithTimeout:(NSTimeInterval)timeout;

@property (nonatomic, readonly, getter=isGeocoding) BOOL geocoding;
- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(YCReverseGeocodeCompletionHandler)completionHandler;
- (void)cancel;


@end
