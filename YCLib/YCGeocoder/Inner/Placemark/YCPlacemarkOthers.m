//
//  YCPlacemarkOthers.m
//  iAlarm
//
//  Created by li shiyong on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "NSString+YC.h"
#import "YCPlacemarkOthers.h"

@interface YCPlacemarkOthers (private)

/**
 _addressDictionary中有效的项目数
 **/
- (NSInteger)_validItemCount; 

@end

@implementation YCPlacemarkOthers

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (NSInteger)_validItemCount{
    NSInteger count = 0;
    
    if ([_addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey]) 
        count ++;
    if ([_addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey]) 
        count ++;
    if ([_addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey]) 
        count ++;
    if ([_addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey]) 
        count ++;
    if ([_addressDictionary objectForKey:(NSString *)kABPersonAddressCountryKey]) 
        count ++;
    
    return count;
}

- (NSString *)longAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:_addressDictionary];
    if ([self _validItemCount] > 2) {//除了邮编至少还有2个
        [newDic removeObjectForKey:(NSString*)kABPersonAddressZIPKey];
    }
        
    if ([self _validItemCount] > 2) {//除了国家至少还有2个
        [newDic removeObjectForKey:(NSString*)kABPersonAddressCountryKey];
    }
    
    NSString *address = ABCreateStringWithAddressDictionary(newDic,NO);
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:_separater];
    address = [address stringByTrim];
    address = (address.length > 0) ? address :nil;
    return address ? address : self.formattedAddress;
}

- (NSString *)shortAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:_addressDictionary];
    
    //去掉邮编、国家名、省份
    [newDic removeObjectForKey:(NSString*)kABPersonAddressZIPKey];
    [newDic removeObjectForKey:(NSString*)kABPersonAddressCountryKey];
    [newDic removeObjectForKey:(NSString*)kABPersonAddressStateKey];
    
    NSString *address = ABCreateStringWithAddressDictionary(newDic,NO);
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:_separater];
    address = [address stringByTrim];
    address = (address.length > 0) ? address :nil;
    return address ? address : self.longAddress;
}

- (NSString *)titleAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:_addressDictionary];
    
    //去掉邮编、国家名、省份、城市
    [newDic removeObjectForKey:(NSString*)kABPersonAddressZIPKey];
    [newDic removeObjectForKey:(NSString*)kABPersonAddressCountryKey];
    [newDic removeObjectForKey:(NSString*)kABPersonAddressStateKey];
    [newDic removeObjectForKey:(NSString*)kABPersonAddressCityKey];
    
    NSString *address = ABCreateStringWithAddressDictionary(newDic,NO);
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:_separater];
    address = [address stringByTrim];
    address = (address.length > 0) ? address :nil;
    return address ? address : self.shortAddress;
}


@end
