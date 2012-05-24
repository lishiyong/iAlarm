//
//  YCMKLocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCFunctions.h"
#import "OffsetDataDao.h"
#import "OffsetData.h"
#import "YCLocationManager.h"

@interface YCLocationManager (private) 

- (OffsetData*)offsetDataWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end


@implementation YCLocationManager


- (OffsetData*)offsetDataWithCoordinate:(CLLocationCoordinate2D)coordinate{
    /*
    NSInteger ilat = coordinate.latitude *10;
    NSInteger ilng = coordinate.longitude *10;
    NSString *lat =  [NSString stringWithFormat:@"%.1f",ilat/10.0];
    NSString *lng =  [NSString stringWithFormat:@"%.1f",ilng/10.0];
     
     NSLog(@"coordinate: %@",NSStringFromCLLocationCoordinate2D(coordinate));
     NSLog(@"OffsetData: %@",offsetData);
     */ 
    
    @try {
        NSString *lat =  [NSString stringWithFormat:@"%.1f",coordinate.latitude];
        NSString *lng =  [NSString stringWithFormat:@"%.1f",coordinate.longitude];
        
        OffsetDataDao *dao = [[[OffsetDataDao alloc] init] autorelease];
        OffsetData *offsetData = [dao findOffsetDataWithLatitude:lat longitude:lng];
        
        return offsetData;
    }@catch (NSException *exception) {
        return nil;
    }
    
}

/**
 是否转换中国境内的坐标
 **/
- (BOOL)chinaShiftEnabled{
    return YES;
}

/**
 坐标是否在中国境内
 **/
#define kMinChinaLatitude  18.0
#define kMaxChinaLatitude  53.5
#define kMinChinaLongitude 73.5
#define kMaxChinaLongitude 134.7

- (BOOL)isInChinaWithCoordinate:(CLLocationCoordinate2D) coordinate{
    if (!CLLocationCoordinate2DIsValid(coordinate)) 
        return NO;
    
    if (coordinate.latitude >= kMinChinaLatitude && coordinate.latitude <= kMaxChinaLatitude 
        && coordinate.longitude >= kMinChinaLongitude &&  coordinate.longitude <= kMaxChinaLongitude) {//先大概算一下
        return [self offsetDataWithCoordinate:coordinate] ? YES : NO;
    }else{
        return NO;
    }
}

/**
 把“正常坐标”转换成“火星坐标”
 **/
- (CLLocationCoordinate2D)convertToMarsCoordinateFromCoordinate:(CLLocationCoordinate2D)coordinate{
    if (!CLLocationCoordinate2DIsValid(coordinate)) 
        return coordinate;
    
    OffsetData *offsetData = [self offsetDataWithCoordinate:coordinate];
    if (offsetData) {
        CLLocationCoordinate2D marsCoordinate = (CLLocationCoordinate2D){coordinate.latitude + offsetData.offsetLatitude, coordinate.longitude + offsetData.offsetLongitude};
        return marsCoordinate;
    }else{
        return coordinate;
    }
}

/**
 把“火星坐标”转换成“正常坐标”
 **/
- (CLLocationCoordinate2D)convertToCoordinateFromMarsCoordinate:(CLLocationCoordinate2D)marsCoordinate{
    if (!CLLocationCoordinate2DIsValid(marsCoordinate)) 
        return marsCoordinate;
    
    OffsetData *offsetData = [self offsetDataWithCoordinate:marsCoordinate];
    if (offsetData) {
        CLLocationCoordinate2D coordinate = (CLLocationCoordinate2D){marsCoordinate.latitude - offsetData.offsetLatitude, marsCoordinate.longitude - offsetData.offsetLongitude};
        return coordinate;
    }else{
        return marsCoordinate;
    }
}


static YCLocationManager *single = nil;
+ (YCLocationManager*)sharedLocationManager{
    if (single == nil) {
        single = [[super allocWithZone:NULL] init];
    }
    return single;
}

- (id)init{
    self = [super init];
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedLocationManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
