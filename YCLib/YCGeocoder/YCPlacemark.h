//
//  YCPlacemark.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>
#import <Foundation/Foundation.h>

@interface YCPlacemark : NSObject<NSCoding>{
    
@package
    CLPlacemark *_placemark;
    NSMutableDictionary *_addressDictionary; //CLPlacemark中的不能修改
    NSString *_separater;//地址中间的分隔
    NSString *_countryCode;
    NSString *_name;
    CLRegion *_region;
    CLLocation *_location;
    NSString *_formattedAddress;
}

- (id)initWithPlacemark:(id/*CLPlacemark MKPlacemark*/)aPlacemark;

/**
 使用 addressDictionary中的 FormattedAddressLines
 或 ABCreateStringWithAddressDictionary函数格式化
 **/
- (NSString *)formattedAddressLines;

/**
 使用 google地址解析结果中的第一个formatted_address
 **/
- (NSString *)formattedAddress;

/**
 中国辽宁省沈阳市和平区和平南大街96巷1号
 日本千叶县松户市 五香西３丁目−２７−３４
 37 Gramercy Park E,Manhattan,纽约州 10003 美国 (不要区的这个级别，要邮编)
 **/
- (NSString *)fullAddress;

/**
 辽宁省沈阳市和平区和平南大街96巷1号
 千叶县松户市 五香西３丁目−２７−３４
 37 Gramercy Park E,Manhattan,纽约州 10003 (不要区的这个级别，要邮编)
 **/
- (NSString *)longAddress;

/**
 沈阳市和平区和平南大街96巷1号
 松户市 五香西３丁目−２７−３４
 37 Gramercy Park E,Manhattan
 **/
- (NSString *)shortAddress;

/**
 和平南大街96巷1号
 五香西 ３丁目−２７−３４
 37 Gramercy Park E
 **/
- (NSString *)titleAddress;

- (NSString *)country;
- (NSString *)state;
- (NSString *)subState;
- (NSString *)city;
- (NSString *)subCity;
- (NSString *)street;
- (NSString *)subStreet;
- (NSString *)zip;
- (NSString *)countryCode;
- (NSString *)name;
- (CLRegion *)region;
- (CLLocation *)location;

/**
 把带换行的地址格式化成一行
 **/
- (NSString*)_addressForAddressLines:(NSString*)addressLines;

@end
