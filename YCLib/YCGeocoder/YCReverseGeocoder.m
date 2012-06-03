//
//  YCGeocoder.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlaceholderReverseGeocoder.h"
#import "YCReverseGeocoder.h"

NSString *YCGeocodeErrorDomain = @"YCGeocodeErrorDomain";

@implementation YCReverseGeocoder
@synthesize timeout = _timeout;

+ (id)allocWithZone:(NSZone *)zone{
    return [YCPlaceholderReverseGeocoder allocWithZone:zone];
}

- (id)init{
    self = [self initWithTimeout:10];
    return self;
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    self = [super init];
    if (self) {
        _timeout = timeout;
    }
    return self;
}

- (BOOL)isGeocoding{return NO;};
- (void)cancel{}
- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(YCReverseGeocodeCompletionHandler)completionHandler{}

@end
