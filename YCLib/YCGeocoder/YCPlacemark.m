//
//  YCPlacemark.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"
#import "NSString+YC.h"
#import "YCPlaceholderPlacemark.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "YCPlacemark.h"

@implementation YCPlacemark

+ (id)allocWithZone:(NSZone *)zone{
    return [YCPlaceholderPlacemark allocWithZone:zone];
}

- (id)init{
    MKPlacemark *aPlacemark = [[[MKPlacemark alloc] 
                                initWithCoordinate:kCLLocationCoordinate2DInvalid addressDictionary:nil] autorelease];
    self = [self initWithPlacemark:aPlacemark];
    return self;
}

- (id)initWithPlacemark:(id)aPlacemark{
    self = [super init];
    if (self) {
        _placemark = [aPlacemark retain];
        _addressDictionary = [[NSMutableDictionary dictionaryWithDictionary:_placemark.addressDictionary] retain];
        //默认的分隔符
        _separater = [[NSString stringWithFormat:@" "] retain]; 
        
        //4.x,5.0later的aPlacemark的类型不一样
        if ([(NSObject*)aPlacemark isKindOfClass: [MKPlacemark class]]) {
            
            _countryCode = [(MKPlacemark*)aPlacemark countryCode];
        }else if ([(NSObject*)aPlacemark isKindOfClass: [CLPlacemark class]]) {
            
            _countryCode = [(CLPlacemark*)aPlacemark ISOcountryCode];
        }else{
            
            _countryCode = @"others";
        }
        _countryCode = [[[_countryCode uppercaseString] stringByTrim] retain];
    
        
        //系统bug，无街道。先找一次，如果没找到，替代：区。
        if (![_placemark.addressDictionary objectForKey:(NSString *) kABPersonAddressStreetKey]) {
            NSString *street = self.street;
            if (!street) 
                street = self.subCity;

            NSMutableString *streetAndSubStreet= [NSMutableString stringWithString:(self.subStreet ? self.subStreet : @"")];
            [streetAndSubStreet appendString:@" "];
            [streetAndSubStreet appendString:(street ? street : @"")];
            NSString *streetAndSubStreet1 = [streetAndSubStreet stringByTrim];
            if (streetAndSubStreet1.length > 0) 
                [_addressDictionary setObject:streetAndSubStreet1 forKey:(NSString *) kABPersonAddressStreetKey];
            
        }
        
        //系统bug，无城市。先找一次，如果没找到，替代：先区，再副省。
        if (![_placemark.addressDictionary objectForKey:(NSString *) kABPersonAddressCityKey]) {
            NSString *city = self.city;
            if (!city) 
                city = self.subCity;
            if (!city) 
                city = self.subState;
            
            if (city) 
                [_addressDictionary setObject:city forKey:(NSString *) kABPersonAddressCityKey];

        }
        
        //系统bug，无省。先找一次，如果没找到，替代：副省。
        if (![_placemark.addressDictionary objectForKey:(NSString *) kABPersonAddressStateKey]) {
            NSString *state = self.state;
            if (!state) 
                state = self.subState;
            
            if (state) 
                [_addressDictionary setObject:state forKey:(NSString *) kABPersonAddressStateKey];

        }
        
        //去掉_addressDictionary中重复的数据
        NSString *city = [[_addressDictionary objectForKey:(NSString *) kABPersonAddressCityKey] stringByTrim];
        NSString *state = [[_addressDictionary objectForKey:(NSString *) kABPersonAddressStateKey] stringByTrim];
        if (city && state) {
            if ([city isEqualToString:state]) 
                [_addressDictionary removeObjectForKey:(NSString *) kABPersonAddressStateKey];
        }
    
    }
     
    return self;
}

- (void)dealloc{
    [_placemark release];
    [_addressDictionary release];
    [_separater release];
    [_countryCode release];
    [super dealloc];
}

#pragma mark - NSCoding

#define    kmyPlacemark                                 @"kmyPlacemark"
#define    kmyaddressDictionary                         @"kmyaddressDictionary"
#define    kseparater                                   @"kseparater"
#define    kmyCountryCode                               @"kmyCountryCode"
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    if ([_placemark conformsToProtocol: @protocol(NSCoding)])
        [encoder encodeObject:_placemark forKey:kmyPlacemark];
    [encoder encodeObject:_addressDictionary forKey:kmyaddressDictionary];
    [encoder encodeObject:_separater forKey:kseparater];
    [encoder encodeObject:_countryCode forKey:kmyCountryCode];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {	

        _separater = [[decoder decodeObjectForKey:kseparater] retain];
        _addressDictionary = [[decoder decodeObjectForKey:kmyaddressDictionary] retain];
        _countryCode = [[decoder decodeObjectForKey:kmyCountryCode] retain];
        
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

#pragma mark - Override Super

- (NSString *)description{
    return [_placemark description];
}


#pragma mark - 

- (NSString *)formattedFullAddressLines{
    NSString *address = [ABCreateStringWithAddressDictionary(_addressDictionary,NO) stringByTrim];
    address = (address.length > 0) ? address : nil;
    if (!address) {
        if ([_placemark respondsToSelector:@selector(name)]) {
            address = _placemark.name;
        }
        if ([_placemark respondsToSelector:@selector(ocean)]) {
            address = _placemark.ocean;
        }
        if ([_placemark respondsToSelector:@selector(inlandWater)]) {
            address = _placemark.name;
        }
    }
    address = [address stringByTrim];
    return (address.length > 0) ? address : nil ;
}

- (NSString *)longAddress{
    return nil;
}

- (NSString *)shortAddress{
    return nil;
}

- (NSString *)titleAddress{
    return nil;
}

#pragma mark - 

- (NSString *)country{
    return [_placemark.country stringByTrim];
}

- (NSString *)state{
    return [_placemark.administrativeArea stringByTrim];
}

- (NSString *)subState{
    return [_placemark.subAdministrativeArea stringByTrim];
}

- (NSString *)city{
    return [_placemark.locality stringByTrim];
}

- (NSString *)subCity{
    return [_placemark.subLocality stringByTrim];
}

- (NSString *)street{
    NSString *street = [_placemark.thoroughfare stringByTrim];
    NSString *subCity = self.subCity;
    
    //排除街道中包含区的名字
    if ([street hasPrefix:subCity] || [street hasSuffix:subCity]) {
        street = [street stringByReplacingOccurrencesOfString:subCity withString:@""];
        street = [street stringByTrim];
    }
    
    return street;
}

- (NSString *)subStreet{
    return [_placemark.subThoroughfare stringByTrim];
}

- (NSString *)zip{
    return [[_addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey] stringByTrim];
}

- (NSString *)countryCode{
    return _countryCode;
}

- (void)debug{
    
        NSLog(@"_placemark = %@",_placemark);
        NSLog(@"formattedFullAddressLines = %@",[self formattedFullAddressLines]);
    
        NSLog(@"====================");
    
        NSLog(@"longAddress = %@",[self longAddress]);
        NSLog(@"shortAddress = %@",[self shortAddress]);
        NSLog(@"titleAddress = %@",[self titleAddress]);
        
        NSLog(@"====================");

        NSLog(@"country = %@",[self country]);
        NSLog(@"state = %@",[self state]);
        NSLog(@"subState = %@",[self subState]);
        NSLog(@"city = %@",[self city]); 
        NSLog(@"subCity = %@",[self subCity]);
        NSLog(@"street = %@",[self street]);
        NSLog(@"subStreet = %@",[self subStreet]);
        NSLog(@"zip = %@",[self zip]);
        NSLog(@"countryCode = %@",[self countryCode]);
        
}

@end
