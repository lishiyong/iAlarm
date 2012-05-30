//
//  YCPlacemarkJP.m
//  iAlarm
//
//  Created by li shiyong on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+YC.h"
#import <AddressBookUI/AddressBookUI.h>
#import "YCPlacemarkJPCN.h"

@implementation YCPlacemarkJPCN

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithPlacemark:(id)aPlacemark{
    self = [super initWithPlacemark:aPlacemark];
    if (self) {
        _separater = [[NSString stringWithFormat:@"−"] retain]; 
    }
    return self;
}

/**
 千叶县松户市 五香西３丁目−２７−３４
 **/
- (NSString *)longAddress{
    
    NSMutableString *address = [NSMutableString string];
    [address appendString:(self.state ? self.state : @"")];
    [address appendString:(self.subState ? self.subState : @"")];
    [address appendString:(self.city ? self.city : @"")];
    [address appendString:@" "];
    [address appendString:(self.subCity ? self.subCity : @"")];
    [address appendString:(self.street ? self.street : @"")];
    if (self.subStreet) {
        [address appendString:_separater];
        [address appendString:(self.subStreet ? self.subStreet : @"")];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.formattedFullAddressLines;
}

/**
 松户市 五香西３丁目−２７−３４
 **/
- (NSString *)shortAddress{
    //没有城市，替代:先副省，再省
    NSString * city = self.city ? self.city : self.subState; 
    city = city ? city : self.state;
    
    NSMutableString *address = [NSMutableString string];
    [address appendString:city];
    [address appendString:@" "];
    [address appendString:(self.subCity ? self.subCity : @"")];
    [address appendString:(self.street ? self.street : @"")];
    if (self.subStreet) {
        [address appendString:_separater];
        [address appendString:(self.subStreet ? self.subStreet : @"")];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.longAddress;
}

/**
 五香西３丁目−２７−３４
 **/
- (NSString *)titleAddress{
    //没有区，替代:先市，再副省，再省
    NSString * subCity = self.subCity ? self.subCity : self.city; 
    subCity = subCity ? subCity : self.subState;
    subCity = subCity ? subCity : self.state;
    
    NSMutableString *address = [NSMutableString string];
    [address appendString:(subCity ? subCity : @"")];
    [address appendString:(self.street ? self.street : @"")];
    if (self.subStreet) {
        [address appendString:_separater];
        [address appendString:(self.subStreet ? self.subStreet : @"")];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.shortAddress;
}


@end
