//
//  YCPlaceholderPlacemark.m
//  iAlarm
//
//  Created by li shiyong on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+YC.h"
#import "YCPlacemarkOthers.h"
#import "YCPlacemarkUSCA.h"
#import "YCPlacemarkJPCN.h"
#import "YCPlaceholderPlacemark.h"

@implementation YCPlaceholderPlacemark


- (id)initWithPlacemark:(id)aPlacemark{
    //这里不能用实例变量，因为下面就要重新为子类分配内存。
    
    //4.x,5.0later的aPlacemark的类型不一样 ,
    NSString *countryCode = nil;
    if ([(NSObject*)aPlacemark isKindOfClass: [MKPlacemark class]]) {
        
        countryCode = [(MKPlacemark*)aPlacemark countryCode];
    }else if ([(NSObject*)aPlacemark isKindOfClass: [CLPlacemark class]]) {
        
        countryCode = [(CLPlacemark*)aPlacemark ISOcountryCode];
    }else{
        
        countryCode = @"others";
    }
    countryCode = [[countryCode uppercaseString] stringByTrim];

        
    id obj = nil;
    if ([countryCode isEqualToString:@"JP"] 
           || [countryCode isEqualToString:@"CN"]
           || [countryCode isEqualToString:@"TW"]
           || [countryCode isEqualToString:@"HK"])  {
        
        obj = [[YCPlacemarkJPCN alloc] initWithPlacemark:aPlacemark];
    }else if ([countryCode isEqualToString:@"US"] || [countryCode isEqualToString:@"CA"]) {
        
        obj = [[YCPlacemarkUSCA alloc] initWithPlacemark:aPlacemark];
    }else{
        
        obj = [[YCPlacemarkOthers alloc] initWithPlacemark:aPlacemark];
    }
    
    return obj;
}

static YCPlaceholderPlacemark *single = nil;
+ (id)allocWithZone:(NSZone *)zone
{
    if (single == nil) {
        single = NSAllocateObject([self class], 0, zone);
    }
    return single;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
