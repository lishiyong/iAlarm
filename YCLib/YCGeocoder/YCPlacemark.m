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
        _placemark = [aPlacemark retain];
        _addressDictionary = [[NSMutableDictionary dictionaryWithDictionary:_placemark.addressDictionary] retain];
        
        //系统bug，街道信息不全。这里补上。
        if (![_addressDictionary objectForKey:(NSString *) kABPersonAddressStreetKey]) {
            NSString *subLocality = [_addressDictionary objectForKey:@"SubLocality"];//区。用区代替街
            NSString *subThoroughfare = [_addressDictionary objectForKey:@"SubThoroughfare"];//门牌
            subLocality = subLocality ? subLocality : @"";
            subThoroughfare = subThoroughfare ? subThoroughfare : @"";
            
            NSString *street = [NSString stringWithFormat:@"%@ %@",subLocality,subThoroughfare];
            [_addressDictionary setObject:street forKey:(NSString *) kABPersonAddressStreetKey];
        }
        
        //地址数据分隔
        NSString *countryCode = [_addressDictionary objectForKey:(NSString *)kABPersonAddressCountryCodeKey];
        countryCode = [countryCode uppercaseString];
        if ([countryCode isEqualToString:@"JP"] 
            || [countryCode isEqualToString:@"CN"]
            || [countryCode isEqualToString:@"TW"]
            || [countryCode isEqualToString:@"HK"]) 
        {//中国，日本用
            
            _separater = [[NSString stringWithFormat:@" "] retain];
        }else{//其他国家用
            _separater = [[NSString stringWithFormat:@","] retain];
        }
         
        //NSLog(@"placemark = %@",[_placemark description]);
        //[self fullAddress];
    }
    return self;
}

- (void)dealloc{
    [_placemark release];
    [_addressDictionary release];
    [_separater release];
    [super dealloc];
}

- (NSString *)fullAddress{
    NSString *address = ABCreateStringWithAddressDictionary(_addressDictionary,NO);
    NSString *address1 = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //NSLog(@"替换前 address1 = %@",address1);
    address1 = [address1 stringByReplacingOccurrencesOfString:@"\n" withString:_separater];
    //NSLog(@"替换后 address1 = %@",address1);
    return address1;
}


- (NSString *)longAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:_addressDictionary];
    if (newDic.count > 1) {//除了邮编至少还有一个
        [newDic removeObjectForKey:(NSString*)kABPersonAddressZIPKey];
    }
    NSString *address = ABCreateStringWithAddressDictionary(newDic,NO);
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:_separater];
    return address;
}

- (NSString *)shortAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:_addressDictionary];
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
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:_separater];
    return address;
}

- (NSString *)titleAddress{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:_addressDictionary];
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
    return [_placemark description];
}


#pragma mark - NSCoding

#define    kmyPlacemark                                 @"kmyPlacemark"
#define    kmyaddressDictionary                         @"kmyaddressDictionary"
#define    kseparater                                   @"kseparater"
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    if ([_placemark conformsToProtocol: @protocol(NSCoding)])
        [encoder encodeObject:_placemark forKey:kmyPlacemark];
    [encoder encodeObject:_addressDictionary forKey:kmyaddressDictionary];
    [encoder encodeObject:_separater forKey:kseparater];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {	

        _separater = [[decoder decodeObjectForKey:kseparater] retain];
        _addressDictionary = [[decoder decodeObjectForKey:kmyaddressDictionary] retain];
        
        if ([_placemark conformsToProtocol: @protocol(NSCoding)]) {            
            _placemark = [[decoder decodeObjectForKey:kmyPlacemark] retain];
            
            if (_placemark == nil) {//从4.x的代码升级过来的情况
                _placemark = [[MKPlacemark alloc] initWithCoordinate:kCLLocationCoordinate2DInvalid addressDictionary:_addressDictionary];
            }            
        }else{//兼容4.x的代码
            _placemark = [[MKPlacemark alloc] initWithCoordinate:kCLLocationCoordinate2DInvalid addressDictionary:_addressDictionary];
        }
        
    }
    
    return self;
}

@end
