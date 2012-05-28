//
//  YCPlacemark.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "YCPlacemark.h"

@implementation YCPlacemark

- (id)initWithPlacemark:(id)aPlacemark{
    self = [super init];
    if (self) {
        placemark = [aPlacemark retain];
        NSLog(@"placemark = %@",placemark);
    }
    return self;
}

- (void)dealloc{
    [placemark release];
    [super dealloc];
}

- (NSString *)fullAddress{
    NSString *address = ABCreateStringWithAddressDictionary([(CLPlacemark*)placemark addressDictionary],NO);
    NSString *address1 = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    address1 = [address1 stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    return address1;
}


- (NSString *)longAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:placemark.addressDictionary];
    if (newDic.count > 1) {//除了邮编至少还有一个
        [newDic removeObjectForKey:(NSString*)kABPersonAddressZIPKey];
    }
    NSString *address = ABCreateStringWithAddressDictionary(newDic,NO);
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    return address;
}

- (NSString *)shortAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:placemark.addressDictionary];
    if (newDic.count > 1) {//除了邮编至少还有一个
        [newDic removeObjectForKey:(NSString*)kABPersonAddressZIPKey];
        
        if ([newDic objectForKey:(NSString*)kABPersonAddressCityKey] || [newDic objectForKey:(NSString*)kABPersonAddressStreetKey]) {
            //去掉国家名、省份
            [newDic removeObjectForKey:(NSString*)kABPersonAddressCountryKey];
            [newDic removeObjectForKey:(NSString*)kABPersonAddressStateKey];
            [newDic removeObjectForKey:@"SubAdministrativeArea"];// 省份的小标题。 这个key没找到
        }
        
    }
    
    NSString *address = ABCreateStringWithAddressDictionary(newDic,NO);
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    return address;
}

- (NSString *)titleAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:placemark.addressDictionary];
    if (newDic.count > 1) {//除了邮编至少还有一个
        [newDic removeObjectForKey:(NSString*)kABPersonAddressZIPKey];
        
        if ([newDic objectForKey:(NSString*)kABPersonAddressCityKey] || [newDic objectForKey:(NSString*)kABPersonAddressStreetKey]) {
            //去掉国家名、省份
            [newDic removeObjectForKey:(NSString*)kABPersonAddressCountryKey];
            [newDic removeObjectForKey:(NSString*)kABPersonAddressStateKey];
            [newDic removeObjectForKey:@"SubAdministrativeArea"];// 省份的小标题。 这个key没找到
            
            if ([newDic objectForKey:(NSString*)kABPersonAddressStreetKey]) {
                //去掉城市
                [newDic removeObjectForKey:(NSString*)kABPersonAddressCityKey];
            }
        }
        
    }
    
    NSString *address = ABCreateStringWithAddressDictionary(newDic,NO);
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [address stringByReplacingOccurrencesOfString:@"\n" withString:@","];
}

- (NSString *)description{
    return [placemark description];
}


#pragma mark NSCoding

#define    kmyPlacemark               @"kmyPlacemark"
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:placemark forKey:kmyPlacemark];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {	
        placemark = [[decoder decodeObjectForKey:kmyPlacemark] retain];
    }
    return self;
}

/*
#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	YCPlacemark *copy = [[[self class] allocWithZone: zone] initWithPlacemark:placemark];    
    return copy;
}
 */

@end
