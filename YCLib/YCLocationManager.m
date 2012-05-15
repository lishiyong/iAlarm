//
//  YCMKLocationManager.m
//  iAlarm
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OffsetDataDao.h"
#import "OffsetData.h"
#import "YCLocationManager.h"

@interface YCLocationManager (private) 

- (OffsetData*)offsetDataWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end


@implementation YCLocationManager


- (OffsetData*)offsetDataWithCoordinate:(CLLocationCoordinate2D)coordinate{
    NSString *lat =  [NSString stringWithFormat:@"%.1f",coordinate.latitude];
    NSString *lng =  [NSString stringWithFormat:@"%.1f",coordinate.longitude];
    
    OffsetDataDao *dao = [[[OffsetDataDao alloc] init] autorelease];
    OffsetData *offsetData = [dao findOffsetDataWithLatitude:lat longitude:lng];
    return offsetData;

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
- (BOOL)isInChinaWithCoordinate:(CLLocationCoordinate2D) coordinate{
    return [self offsetDataWithCoordinate:coordinate] ? YES : NO;
}

/**
 把“正常坐标”转换成“火星坐标”
 **/
- (CLLocationCoordinate2D)convertToMarsCoordinateFromCoordinate:(CLLocationCoordinate2D)coordinate{
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
