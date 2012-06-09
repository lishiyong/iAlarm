//
//  YCForwardGeocoderManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCMaps.h"
#import "YCDouble.h"
#import "NSObject+YC.h"
#import "NSValue+YC.h"
#import "YCForwardGeocoderManager.h"

@interface YCForwardGeocoderManager (private)

- (void)_prepare;
- (void)_forwardGeocode:(YCForwardGeocoder*)geocoder addressString:(NSString *)addressString viewportBiasing:(NSObject*)viewportBiasing;
- (void)_forwardGeocode:(YCForwardGeocoder*)geocoder addressDictionary:(NSDictionary *)addressDictionary;
- (void)_handleGeocodeCompletionWithError:(NSError*)error;

@end

@implementation YCForwardGeocoderManager

- (id)init{
    self = [super init];
    if (self) {
        _results = [[NSMutableSet set] retain];
        _geocoders = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)dealloc{
    [self _prepare];
    [_forwardGeocodeCompletionHandler release];
    [_results release];
    [_geocoders release];
    [_reservedViewportBiasings release];
    [_addressString release];
    [_addressTitle release];
}

- (void)cancel{
    _canceled = YES;
    
    for (YCForwardGeocoder *anObj in _geocoders) {
        if ([(YCForwardGeocoder*) anObj isGeocoding])
            [(YCForwardGeocoder*) anObj cancel];
    }
    [_geocoders removeAllObjects];
    [_results removeAllObjects];
}

- (void)_handleGeocodeCompletionWithError:(NSError*)error{
    NSLog(@"_geocoders.count = %d",_geocoders.count);
    
    if (_canceled) 
        return;
    
    if (_geocoders.count != 0) //还有的在查询
        return;
    
    NSLog(@"_geocoders.count = %d _results.count = %d",_geocoders.count,_results.count);
    
    if (_results.count > 0) {//有一个结果，就不返回错误
        _forwardGeocodeCompletionHandler(_results.allObjects,nil);
        [_results removeAllObjects];
    }else if (_reservedViewportBiasings && _reservedViewportBiasings.count > 0){
        //无结果，用备用视口再查询一遍
        NSArray *viewports = [_reservedViewportBiasings retain];
        YCforwardGeocodeCompletionHandler blockHandler = [_forwardGeocodeCompletionHandler copy];
        NSString *addressString = [_addressString copy];
        
        [self forwardGeocodeAddressString:addressString viewportBiasings:viewports reservedViewportBiasings:nil completionHandler:blockHandler];
        
        [viewports release];
        [blockHandler release];
        [addressString release];
    }else{
        _forwardGeocodeCompletionHandler(nil,error);//返回最后一次的错误
    }
}

- (void)_forwardGeocode:(YCForwardGeocoder*)geocoder addressString:(NSString *)addressString viewportBiasing:(NSObject*)viewportBiasing
{
    
    YCforwardGeocodeCompletionHandler theBlock = ^(NSArray *placemarks, NSError *error){
        if (!error && placemarks.count >0 ) {
            //查询成功。YCPlacemark类覆写了isEqual:、hash,所以在set数据结构中不会有坐标重复的。            
            [_results addObjectsFromArray:placemarks];
        }
        [_geocoders removeObject:geocoder];
        [self _handleGeocodeCompletionWithError:error];
    };
    
    if ([viewportBiasing isKindOfClass:[CLRegion class]]){
        [geocoder forwardGeocodeAddressString:addressString inRegion:(CLRegion*)viewportBiasing completionHandler:theBlock];
    }else{
        MKMapRect mapRect = [(NSValue*)viewportBiasing mapRectValue];
        [geocoder forwardGeocodeAddressString:addressString inMapRect:mapRect completionHandler:theBlock];
    }
    
}

- (void)_forwardGeocode:(YCForwardGeocoder*)geocoder addressDictionary:(NSDictionary *)addressDictionary
{
    
    YCforwardGeocodeCompletionHandler theBlock = ^(NSArray *placemarks, NSError *error){
        if (!error && placemarks.count >0 ) {
            //查询成功。YCPlacemark类覆写了isEqual:、hash,所以在set数据结构中不会有坐标重复的。            
            [_results addObjectsFromArray:placemarks];
        }
        [_geocoders removeObject:geocoder];
        [self _handleGeocodeCompletionWithError:error];
    };
    
    [geocoder forwardGeocodeAddressDictionary:addressDictionary completionHandler:theBlock];
    
}

- (void)_prepare{
    //先都停止解析,再清空结果集
    [_geocoders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([(YCForwardGeocoder*) obj isGeocoding])
            [(YCForwardGeocoder*) obj cancel];
    }];
    [_geocoders removeAllObjects];
    
    [_results removeAllObjects];
    
    if (_forwardGeocodeCompletionHandler) {
        [_forwardGeocodeCompletionHandler release];
        _forwardGeocodeCompletionHandler = nil;
    }
    
    [_reservedViewportBiasings release];
    _reservedViewportBiasings = nil;
    
    [_addressString release];
    _addressString = nil;
    
    [_addressDictionary release];
    _addressDictionary = nil;
    
    [_addressTitle release];
    _addressTitle = nil;
    
    _canceled = NO;
}

- (void)forwardGeocodeAddressString:(NSString *)addressString viewportBiasings:(NSArray*)viewportBiasings reservedViewportBiasings:(NSArray*)reservedViewportBiasings  completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    [self _prepare];
    _forwardGeocodeCompletionHandler = [completionHandler copy];
    _reservedViewportBiasings = [reservedViewportBiasings retain];
    _addressString = [addressString copy];
    
    NSTimeInterval timeoutA = 0;
    NSTimeInterval timeoutB = 0;
    if (reservedViewportBiasings && reservedViewportBiasings.count >0) {//用备用视口来判断是不是第一次搜索
        timeoutA = 5.0;
        timeoutB = 10.0; //第一次时间短点
    }else{
        timeoutA = 12;
        timeoutB = 30.0;
    }
    
    for (id anObj in viewportBiasings) {
        
        
        YCForwardGeocoder *geocoderB = [[[YCForwardGeocoder alloc] initWithTimeout:timeoutB forwardGeocoderType:YCForwardGeocoderTypeBS] autorelease];
        [_geocoders addObject:geocoderB];
        [self _forwardGeocode:geocoderB addressString:addressString viewportBiasing:anObj];
         
        
        //5.0版本才支持 CLGeocoder 这个类
        double systeVersion = [[UIDevice currentDevice].systemVersion doubleValue];
        NSComparisonResult result = YCCompareDouble(systeVersion, 5.0);
        if (result == NSOrderedDescending || result == NSOrderedSame)  {
            
            YCForwardGeocoder *geocoderA = [[[YCForwardGeocoder alloc] initWithTimeout:timeoutA forwardGeocoderType:YCForwardGeocoderTypeApple] autorelease];
            [_geocoders addObject:geocoderA];
            [self _forwardGeocode:geocoderA addressString:addressString viewportBiasing:anObj];
            
        }
         
        
    }
    
}

- (NSString *)addressString;{
    return _addressString;
}

- (NSString *)addressTitle{
    return _addressTitle;
}

- (NSString *)addressDictionary{
    return _addressDictionary;
}

- (void)forwardGeocodeAddressString:(NSString *)addressString visibleMapRect:(MKMapRect)visibleMapRect currentLocation:(CLLocation*)currentLocation completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    //正在查询中
    if (_geocoders.count > 0) 
        return;
    
    
    NSMutableArray *viewports = [NSMutableArray array];
    NSMutableArray *reservedViewports = [NSMutableArray array];
    
    //visibleMapRect = MKMapRectNull;
    //当前地图可视范围的视口
    if (!MKMapRectIsNull(visibleMapRect) && !MKMapRectIsEmpty(visibleMapRect)) {
        [viewports addObject:[NSValue valueWithMapRect:visibleMapRect]];
        
        CLLocationCoordinate2D visCoordinate = YCCoordinateForMapPoint(YCMapRectCenter(visibleMapRect));
        CLLocationDistance visRadius = 250.0;
        
        
        NSArray *visLocRadiuses = [NSArray arrayWithObjects:
                                    [NSNumber numberWithDouble:visRadius*4] //1km
                                   ,[NSNumber numberWithDouble:visRadius*4*2]
                                   ,[NSNumber numberWithDouble:visRadius*4*5]
                                   ,[NSNumber numberWithDouble:visRadius*4*8]
                                   ,[NSNumber numberWithDouble:visRadius*4*50]
                                   ,[NSNumber numberWithDouble:visRadius*4*90]
                                   ,[NSNumber numberWithDouble:visRadius*4*300]
                                   , nil];
         
        
        NSArray *visLocReservedRadiuses = [NSArray arrayWithObjects:
                                            [NSNumber numberWithDouble:visRadius*2]
                                           ,[NSNumber numberWithDouble:visRadius*4*16]
                                           ,[NSNumber numberWithDouble:visRadius*4*30]
                                           ,[NSNumber numberWithDouble:visRadius*4*80]
                                           ,[NSNumber numberWithDouble:visRadius*4*100]
                                           ,[NSNumber numberWithDouble:visRadius*4*500]
                                           ,[NSNumber numberWithDouble:visRadius*4*2000]
                                           , nil];
        
        for (NSInteger i = 0; i < visLocRadiuses.count; i++) {
            NSString * identifier = [NSString stringWithFormat:@"visLocRegions%d",i];
            CLLocationDistance aRadius = [(NSNumber*)[visLocRadiuses objectAtIndex:i] doubleValue];
            CLRegion *aRegion = [[[CLRegion alloc] initCircularRegionWithCenter:visCoordinate radius:aRadius identifier:identifier] autorelease];
            [viewports addObject:aRegion];
        }
        
        for (NSInteger i = 0; i < visLocReservedRadiuses.count; i++) {
            NSString * identifier = [NSString stringWithFormat:@"visLocReservedRegion%d",i];
            CLLocationDistance aRadius = [(NSNumber*)[visLocReservedRadiuses objectAtIndex:i] doubleValue];
            CLRegion *aRegion = [[[CLRegion alloc] initCircularRegionWithCenter:visCoordinate radius:aRadius identifier:identifier] autorelease];
            [reservedViewports addObject:aRegion];
        }

    }
    
            
    //当前位置的视口
    if (currentLocation) { 
        CLLocationCoordinate2D curCoordinate = currentLocation.coordinate;
        CLLocationDistance curRadius = 250.0;
        
        NSArray *curLocRadiuses = [NSArray arrayWithObjects:
                                    [NSNumber numberWithDouble:curRadius*4] //1km
                                   ,[NSNumber numberWithDouble:curRadius*4*2]
                                   ,[NSNumber numberWithDouble:curRadius*4*5]
                                   ,[NSNumber numberWithDouble:curRadius*4*8]
                                   ,[NSNumber numberWithDouble:curRadius*4*30]
                                   ,[NSNumber numberWithDouble:curRadius*4*50]
                                   ,[NSNumber numberWithDouble:curRadius*4*90]
                                   ,[NSNumber numberWithDouble:curRadius*4*180]
                                   ,[NSNumber numberWithDouble:curRadius*4*300]
                                   , nil];
        
        
        NSArray *curLocReservedRadiuses = [NSArray arrayWithObjects:
                                            [NSNumber numberWithDouble:curRadius*2]
                                           ,[NSNumber numberWithDouble:curRadius*4*16]
                                           ,[NSNumber numberWithDouble:curRadius*4*100]
                                           ,[NSNumber numberWithDouble:curRadius*4*500]
                                           ,[NSNumber numberWithDouble:curRadius*4*2000]
                                           , nil];
        
        for (NSInteger i = 0; i < curLocRadiuses.count; i++) {
            NSString * identifier = [NSString stringWithFormat:@"curLocRegions%d",i];
            CLLocationDistance aRadius = [(NSNumber*)[curLocRadiuses objectAtIndex:i] doubleValue];
            CLRegion *aRegion = [[[CLRegion alloc] initCircularRegionWithCenter:curCoordinate radius:aRadius identifier:identifier] autorelease];
            [viewports addObject:aRegion];
        }
        
        for (NSInteger i = 0; i < curLocReservedRadiuses.count; i++) {
            NSString * identifier = [NSString stringWithFormat:@"curLocReservedRegion%d",i];
            CLLocationDistance aRadius = [(NSNumber*)[curLocReservedRadiuses objectAtIndex:i] doubleValue];
            CLRegion *aRegion = [[[CLRegion alloc] initCircularRegionWithCenter:curCoordinate radius:aRadius identifier:identifier] autorelease];
            [reservedViewports addObject:aRegion];
        }
        
    }
    
    
    [self forwardGeocodeAddressString:addressString viewportBiasings:viewports reservedViewportBiasings:reservedViewports completionHandler:^(NSArray *placemarks, NSError *error){
        completionHandler(placemarks,error);
    }];
    
}


- (void)forwardGeocodeAddressDictionary:(NSDictionary *)addressDictionary addressTitle:(NSString*)addressTitle completionHandler:(YCforwardGeocodeCompletionHandler)completionHandler{
    
    //正在查询中
    if (_geocoders.count > 0) 
        return;
    
    
    [self _prepare];
    _forwardGeocodeCompletionHandler = [completionHandler copy];
    _addressDictionary = [addressDictionary retain];
    _addressTitle = [addressTitle copy];
    
    NSTimeInterval timeoutA = 8;
    NSTimeInterval timeoutB = 20;
    
    YCForwardGeocoder *geocoderB = [[[YCForwardGeocoder alloc] initWithTimeout:timeoutB forwardGeocoderType:YCForwardGeocoderTypeBS] autorelease];
    [_geocoders addObject:geocoderB];
    [self _forwardGeocode:geocoderB addressDictionary:addressDictionary];
    
    //5.0版本才支持 CLGeocoder 这个类
    double systeVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    NSComparisonResult result = YCCompareDouble(systeVersion, 5.0);
    if (result == NSOrderedDescending || result == NSOrderedSame)  {
        
        YCForwardGeocoder *geocoderA = [[[YCForwardGeocoder alloc] initWithTimeout:timeoutA forwardGeocoderType:YCForwardGeocoderTypeApple] autorelease];
        [_geocoders addObject:geocoderA];
        [self _forwardGeocode:geocoderA addressDictionary:addressDictionary];
    }
    
}

@end
