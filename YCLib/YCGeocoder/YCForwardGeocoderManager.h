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
    BOOL _canceled;
}


/**
 地址解析，使用多个视口。viewportBiasings与reservedViewportBiasings保存的可能是CLRegion或MKMapRect；
 MKMapRect使用NSValue封装；
 如果viewportBiasings查询没有数据，再使用reservedViewportBiasings
 **/
- (void)forwardGeocodeAddressString:(NSString *)addressString viewportBiasings:(NSArray*)viewportBiasings reservedViewportBiasings:(NSArray*)reservedViewportBiasings  completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler;

- (void)cancel;
- (NSString *)addressString;

@end
