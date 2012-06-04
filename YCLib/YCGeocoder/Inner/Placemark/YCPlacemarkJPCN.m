//
//  YCPlacemarkJP.m
//  iAlarm
//
//  Created by li shiyong on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSMutableString+YC.h"
#import "NSString+YC.h"
#import "YCPlacemarkJPCN.h"

@implementation YCPlacemarkJPCN

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithPlacemark:(id)aPlacemark{
    self = [super initWithPlacemark:aPlacemark];
    if (self) {
        [_separater release];
        if ([_countryCode isEqualToString:@"JP"]) { 
            _separater = [[NSString stringWithFormat:@""] retain]; 
        }else{
            _separater = [[NSString stringWithFormat:@""] retain]; 
        }
        
    }
    return self;
}

/**
 日本千叶县松户市 五香西３丁目２７−３４
 **/
- (NSString *)fullAddress{
    
    NSMutableString *address = [NSMutableString string];
    [address appendAddress:(self.country ? self.country : @"")];
    [address appendAddress:(self.state ? self.state : @"")];
    [address appendAddress:(self.subState ? self.subState : @"")];
    [address appendAddress:(self.city ? self.city : @"")];
    [address appendString:@" "];
    [address appendAddress:(self.subCity ? self.subCity : @"")];
    [address appendAddress:(self.street ? self.street : @"")];
    if (self.subStreet) {
        [address appendString:_separater];
        [address appendAddress:(self.subStreet ? self.subStreet : @"")];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.formattedAddress;
}

/**
 千叶县松户市 五香西３丁目２７−３４
 **/
- (NSString *)longAddress{
    //没有省，替代:国名
    NSString * state = self.state ? self.state : self.country; 
    state = state ? state : @"";
    
    NSMutableString *address = [NSMutableString string];
    [address appendAddress:(state ? state : @"")];
    [address appendAddress:(self.subState ? self.subState : @"")];
    [address appendAddress:(self.city ? self.city : @"")];
    [address appendString:@" "];
    [address appendAddress:(self.subCity ? self.subCity : @"")];
    [address appendAddress:(self.street ? self.street : @"")];
    if (self.subStreet) {
        [address appendString:_separater];
        [address appendAddress:(self.subStreet ? self.subStreet : @"")];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.fullAddress;
}

/**
 松户市 五香西３丁目２７−３４
 **/
- (NSString *)shortAddress{
    //没有城市，替代:先副省，再省，再国名
    NSString * city = self.city ? self.city : self.subState; 
    city = city ? city : self.state;
    city = city ? city : self.country;
    city = city ? city : @"";
    
    NSMutableString *address = [NSMutableString string];
    [address appendAddress:city];
    [address appendString:@" "];
    [address appendAddress:(self.subCity ? self.subCity : @"")];
    [address appendAddress:(self.street ? self.street : @"")];
    if (self.subStreet) {
        [address appendString:_separater];
        [address appendAddress:(self.subStreet ? self.subStreet : @"")];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.longAddress;
}

/**
 五香西 ３丁目２７−３４
 **/
- (NSString *)titleAddress{
    //没有区，替代:先市，再副省，再省
    NSString * subCity = self.subCity ? self.subCity : self.city; 
    subCity = subCity ? subCity : self.subState;
    subCity = subCity ? subCity : self.state;
    subCity = subCity ? subCity : @"";
    
    NSMutableString *address = [NSMutableString string];
    [address appendAddress:(subCity ? subCity : @"")];
    [address appendString:@" "]; //中间的空格
    [address appendAddress:(self.street ? self.street : @"")];
    if (self.subStreet) {
        [address appendString:_separater];
        [address appendAddress:(self.subStreet ? self.subStreet : @"")];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.shortAddress;
}


@end
