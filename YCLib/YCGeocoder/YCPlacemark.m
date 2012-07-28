//
//  YCPlacemark.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSMutableString+YCGeocode.h"
#import "YCFunctions.h"
#import "YCLocation.h"
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
        //NSLog(@"_placemark.addressDictionary = %@",[_placemark.addressDictionary description]);
        _addressDictionary = [_placemark.addressDictionary mutableCopy];
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
    
        _name = [_addressDictionary objectForKey:@"Name"];
        _name = ([[_name stringByTrim] length] > 0 ) ? _name : nil;
        [_name retain];
        _region = [[_addressDictionary objectForKey:@"Region"] retain];
        _location = [[_addressDictionary objectForKey:@"Location"] retain];
        
        
        //BS查询会得到一个格式化地址（formatted_address），它不与MKPlacemark和CLPlacemark对应方法。
        _formattedAddress = [[_addressDictionary objectForKey:@"FormattedAddress"] retain];
        
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
        
        //_placemark.name有可能是完全的地址
        if ([_placemark respondsToSelector:@selector(name)]){ //MKPlacemark在4.x不支持方法：name
            NSString *placemarkName = _placemark.name;
            if (placemarkName) {
                
                BOOL isContainingCountry = NO;
                if (self.country) 
                    isContainingCountry = ([placemarkName rangeOfString:self.country].location != NSNotFound);
                
                BOOL isContainingState = NO;
                if (self.state) 
                    isContainingState = ([placemarkName rangeOfString:self.state].location != NSNotFound);
                
                BOOL isContainingCity = NO;
                if (self.city) 
                    isContainingCity = ([placemarkName rangeOfString:self.city].location != NSNotFound);
                
                BOOL isContainingSubCity = NO;
                if (self.subCity) 
                    isContainingSubCity = ([placemarkName rangeOfString:self.subCity].location != NSNotFound);
                
                BOOL isStreet = NO;
                if (self.street) 
                    isStreet = [[placemarkName stringByTrim] isEqualToString:self.street];
                
                _internalPlacemarkNameIsName = YES;
                //如果name中包含其中的任意3个，就认为name是_formattedAddress,不能做为name使用了。是街道也不行。
                if ((isContainingCountry && isContainingState && isContainingCity)    || 
                    (isContainingCountry && isContainingState && isContainingSubCity) || 
                    (isContainingCountry && isContainingCity  && isContainingSubCity) || 
                    (isContainingState   && isContainingCity  && isContainingSubCity) ||
                    (isStreet)
                    ) {
                    
                    _internalPlacemarkNameIsName = NO;
                    [_name release];
                    _name = nil;
                    
                    if (!_formattedAddress && !isStreet) //如果不是街道，赋给就是_formattedAddress
                        _formattedAddress = [placemarkName retain];
                    
                }
            }
        }//处理_placemark.name结束
    
    }
    /*
    [self performBlock:^{
        [self debug];
    } afterDelay:0.1];
     */
     //NSLog(@"_addressDictionary = %@",[_addressDictionary description]);
     
    return self;
}

- (void)dealloc{    
    NSLog(@"YCPlacemark dealloc");
    [_placemark release];
    [_addressDictionary release];
    [_separater release];
    [_countryCode release];
    [_name release];
    [_region release];
    [_location release];
    [_formattedAddress release];
    [super dealloc];
}

#pragma mark - NSCoding

#define    kmyPlacemark                                 @"kmyPlacemark"
#define    kmyaddressDictionary                         @"kmyaddressDictionary"
#define    kseparater                                   @"kseparater"
#define    kmyCountryCode                               @"kmyCountryCode"
#define    kmyName                                      @"kmyName"
#define    kmyRegion                                    @"kmyRegion"
#define    kmyLocation                                  @"kmyLocation"
#define    kmyFormattedAddress                          @"kmyFormattedAddress"
#define    kmyInternalPlacemarkNameIsName               @"kmyInternalPlacemarkNameIsName"


- (void)encodeWithCoder:(NSCoder *)encoder {
    
    if ([_placemark conformsToProtocol: @protocol(NSCoding)])
        [encoder encodeObject:_placemark forKey:kmyPlacemark];
    [encoder encodeObject:_addressDictionary forKey:kmyaddressDictionary];
    [encoder encodeObject:_separater forKey:kseparater];
    [encoder encodeObject:_countryCode forKey:kmyCountryCode];
    [encoder encodeObject:_name forKey:kmyName];
    [encoder encodeObject:_region forKey:kmyRegion];
    [encoder encodeObject:_location forKey:kmyLocation];
    [encoder encodeObject:_formattedAddress forKey:kmyFormattedAddress];
    [encoder encodeBool:_internalPlacemarkNameIsName forKey:kmyInternalPlacemarkNameIsName];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {	

        _separater = [[decoder decodeObjectForKey:kseparater] retain];
        _addressDictionary = [[decoder decodeObjectForKey:kmyaddressDictionary] retain];
        _countryCode = [[decoder decodeObjectForKey:kmyCountryCode] retain];
        _name = [[decoder decodeObjectForKey:kmyName] retain];
        _region = [[decoder decodeObjectForKey:kmyRegion] retain];
        _location = [[decoder decodeObjectForKey:kmyLocation] retain];
        _formattedAddress = [[decoder decodeObjectForKey:kmyFormattedAddress] retain];
        _internalPlacemarkNameIsName = [decoder decodeBoolForKey:kmyInternalPlacemarkNameIsName];
        
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

- (NSString *)formattedAddressLines{
    NSString *address = [ABCreateStringWithAddressDictionary(_addressDictionary,NO) stringByTrim];
    address = (address.length > 0) ? address : nil;

    if (!address && [_placemark respondsToSelector:@selector(name)]) {
        address = _placemark.name;
    }
    if (!address && [_placemark respondsToSelector:@selector(ocean)]) {
        address = _placemark.ocean;
    }
    if (!address && [_placemark respondsToSelector:@selector(inlandWater)]) {
        address = _placemark.name;
    }
    
    address = [address stringByTrim];
    return (address.length > 0) ? address : nil ;
}

- (NSString *)formattedAddress{
    if (_formattedAddress) 
        return _formattedAddress;
    else {
        NSString *address = [self formattedAddressLines]; 
        return [self _addressForAddressLines:address];
    }
}

- (NSString *)fullAddress{
    return nil;
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
    NSString *subCity = [self.subCity stringByTrim];
    
    //排除街道中包含区的名字
    if (subCity && ([street hasPrefix:subCity] || [street hasSuffix:subCity])) {
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

- (NSString *)name{
    //MKPlacemark在4.x不支持方法：name
    if ([_placemark respondsToSelector:@selector(name)] && _placemark.name 
        &&[_placemark.name stringByTrim].length > 0 && _internalPlacemarkNameIsName)
        return _placemark.name;
    else
        return _name;
}

- (CLRegion *)region{
    //MKPlacemark在4.x不支持方法：region
    if ([_placemark respondsToSelector:@selector(region)] && _placemark.region)
        return _placemark.region;
    else
        return _region;
}

- (CLLocation *)location{
    //MKPlacemark在4.x不支持方法：location
    if ([_placemark respondsToSelector:@selector(location)] && _placemark.location)
        return _placemark.location;
    else
        return _location;
}

- (NSDictionary *)addressDictionary{
    return _placemark.addressDictionary;
}

#pragma mark - Override Super
/**
 坐标相同，就相等
 **/
- (BOOL)isEqual:(id)object{
    
    BOOL isEqual = NO;
    if ([object isKindOfClass:[YCPlacemark class]] ) {
        isEqual = YCCLLocationCoordinate2DEqualToCoordinate(self.region.center, [(YCPlacemark*)object region].center);
    }
    return isEqual;
     
    return YES;
}

- (NSUInteger)hash{
    CLLocationDegrees lat = self.region.center.latitude;
    CLLocationDegrees lng = self.region.center.longitude;
    NSUInteger hashValue = (NSUInteger)((lat + lng)*10000);
    return hashValue;
}

#pragma mark - 

- (NSString*)_addressForAddressLines:(NSString*)addressLines{
    //先分解成Array，然后在逐个添加
    NSArray *addresses = [addressLines componentsSeparatedByString:@"\n"];
    NSMutableString *address = [NSMutableString stringWithCapacity:10];
    for (NSString *anAddress in addresses) {
        [address appendAddress:anAddress separater:_separater];
    }
    
    NSString *address1 = [address stringByTrim];
    return address1;
}

#pragma mark - Test

- (void)debug{
    
    NSLog(@"_placemark = %@",_placemark);
    
    NSLog(@"formattedFullAddressLines = %@",[self formattedAddressLines]);
    NSLog(@"formattedAddress = %@",[self formattedAddress]);
    
    NSLog(@"====================");
    
    NSLog(@"fullAddress = %@",[self fullAddress]);
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
    NSLog(@"name = %@",[self name]);
    
    NSLog(@"_placemarkNameIsFormattedAddress = %@",_internalPlacemarkNameIsName ? @"YES":@"NO");
    
}

- (id)retain{
    return [super retain];
}


@end
