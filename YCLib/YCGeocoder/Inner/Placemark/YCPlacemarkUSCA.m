//
//  YCPlacemarkUS.m
//  iAlarm
//
//  Created by li shiyong on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+YC.h"
#import "YCPlacemarkUSCA.h"

@interface YCPlacemarkUSCA (private)

- (NSString *)_titleAddress;
- (NSString *)_shortAddress;

@end

@implementation YCPlacemarkUSCA

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithPlacemark:(id)aPlacemark{
    self = [super initWithPlacemark:aPlacemark];
    if (self) {
        _addressArray = [[NSMutableArray arrayWithCapacity:10] retain];
        
        if (_placemark.thoroughfare) 
            [_addressArray addObject:_placemark.thoroughfare];
        
        if (!_placemark.thoroughfare || !_placemark.locality) { //街道或市任何一个无效，都导入区
            if (_placemark.subLocality) 
                [_addressArray addObject:_placemark.subLocality];
        }
        
        if (_placemark.locality) 
            [_addressArray addObject:_placemark.locality];
        
        if (!_placemark.locality || !_placemark.administrativeArea) { //市或省任何一个无效，都导入副省
            if (_placemark.subAdministrativeArea) 
                [_addressArray addObject:_placemark.subAdministrativeArea];
        }
        
        if (_placemark.administrativeArea) 
            [_addressArray addObject:_placemark.administrativeArea];
        
        if (_placemark.country) 
            [_addressArray addObject:_placemark.country];
        
        
        [_separater release];
        if ([_countryCode isEqualToString:@"US"]) { 
            _separater = [[NSString stringWithFormat:@","] retain]; 
        }else{
            _separater = [[NSString stringWithFormat:@","] retain]; 
        }
        
    }
    return self;
}

- (void)dealloc{
    [_addressArray release];
    [super dealloc];
}

/**
 37 Gramercy Park E,Manhattan,纽约州 10003 (不要区的这个级别，要邮编)
 **/
- (NSString *)longAddress{
    NSMutableString *address = [NSMutableString string];
    NSString *shortAddress = [self _shortAddress];
    
    [address appendString:(shortAddress ? shortAddress : @"")];
    if (shortAddress && _addressArray.count > 3) //上面有，下边也有才加上“,”
        [address appendString:_separater];
    if (_addressArray.count > 3)
        [address appendString:[_addressArray objectAtIndex:2]];
    
    if (self.zip) {
        [address appendString:@" "];
        [address appendString:self.zip];
    }
    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0 ) ? address1 : self.formattedAddress;
}

/**
 37 Gramercy Park E,Manhattan
 **/
- (NSString *)_shortAddress{
    NSMutableString *address = [NSMutableString string];
    NSString *titleAddress = [self _titleAddress];
    
    [address appendString:(titleAddress ? titleAddress : @"")];
    if (titleAddress && _addressArray.count > 2) //上面有，下边也有才加上“,”
        [address appendString:_separater];
    if (_addressArray.count > 2)
        [address appendString:[_addressArray objectAtIndex:1]];

    
    NSString *address1 = [address stringByTrim];
    return (address1.length > 0) ? address1 : nil;
}

- (NSString *)shortAddress{
    NSString *address = [self _shortAddress];
    return address ? address : self.longAddress;
}

/**
 37 Gramercy Park E
 **/
- (NSString *)_titleAddress{
    NSMutableString *address = [NSMutableString string];
    [address appendString:(self.subStreet ? self.subStreet : @"")];
    
    if (self.subStreet && _addressArray.count > 0) //上面有，下边也有才加上“ ”
        [address appendString:@" "];
        
    if (_addressArray.count > 0)
        [address appendString:[_addressArray objectAtIndex:0]];

    NSString *address1 = [address stringByTrim];
    return (address1.length > 0) ? address1 : nil;
}

- (NSString *)titleAddress{
    NSString *address = [self _titleAddress];
    return address ? address : self.shortAddress;
}

@end
