//
//  YCForwardGeocoderManager.h
//  iAlarm
//
//  Created by li shiyong on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCForwardGeocoder.h"
#import <Foundation/Foundation.h>


@interface YCForwardGeocoderManager : NSObject{
    YCforwardGeocodeCompletionHandler _forwardGeocodeCompletionHandler;
    NSMutableSet *_results;
    NSMutableArray *_geocoders;
    NSArray *_reservedViewportBiasings;
    NSString *_addressString;
    NSDictionary *_addressDictionary;
    NSString *_addressTitle;
    BOOL _canceled;
}


/**
 地址解析，使用多个视口。viewportBiasings与reservedViewportBiasings保存的可能是CLRegion或MKMapRect；
 MKMapRect使用NSValue封装；
 如果viewportBiasings查询没有数据，再使用reservedViewportBiasings
 **/
- (void)forwardGeocodeAddressString:(NSString *)addressString viewportBiasings:(NSArray*)viewportBiasings reservedViewportBiasings:(NSArray*)reservedViewportBiasings  completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;

- (void)forwardGeocodeAddressString:(NSString *)addressString visibleMapRect:(MKMapRect)mapRect currentLocation:(CLLocation*)currentLocation completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;

- (void)forwardGeocodeAddressDictionary:(NSDictionary *)addressDictionary addressTitle:(NSString*)addressTitle completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;

- (void)cancel;
- (NSString *)addressString;
- (NSString *)addressTitle;
- (NSString *)addressDictionary;

@end
