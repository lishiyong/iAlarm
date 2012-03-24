//
//  RegionCenter.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarm.h"
#import <Foundation/Foundation.h>


//区域列表改变，包括：增，改，删
extern NSString *IARegionsDidChangeNotification;
extern NSString *IARegionKey;


@interface IARegionsCenter : NSObject {
	NSMutableDictionary *regions;                    //所有需要监控的区域
    NSArray *regionArray;  //内部使用，为了节约资源
	
	//所有区域，包括未启用的
	NSMutableDictionary *allRegions;
	NSArray *allRegionArray;
}

@property(nonatomic,readonly)NSDictionary *regions;
@property(nonatomic,readonly)NSArray *regionArray;

@property(nonatomic,readonly)NSDictionary *allRegions;


+ (IARegionsCenter*)regionCenterSingleInstance;

/*
//坐标是否在任何一个预警范围中
- (BOOL)preAlarmRegionsContainCoordinate:(CLLocationCoordinate2D)coordinate;
//坐标是否在任何一个大预警范围中
- (BOOL)bigPreAlarmRegionsContainCoordinate:(CLLocationCoordinate2D)coordinate;
 */

//包含这个坐标的区域。没有返回nil
- (NSArray*)containsRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSInteger)numberOfContainsRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate;

//包含这个坐标的的预警区域。没有返回nil
- (NSArray*)containsPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSInteger)numberOfContainsPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate;

//包含这个坐标的大预警区域。没有返回nil
- (NSArray*)containsBigPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSInteger)numberOfContainsBigPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate;


//坐标是否能引起列表中的区域类型发生改变
- (BOOL)canChangeUserLocationTypeForCoordinate:(CLLocationCoordinate2D)coordinate;

//是否能检测出所有区域与theLocation的距离（与theLocation的精度有关）
- (BOOL)canDetermineDistanceFromLocation:(const CLLocation *)theLocation;

//正在运行中：到达时候提醒 且 类型 == IAUserLocationTypeOuter ; 离开时候提醒 且 类型 == IAUserLocationTypeInner
- (BOOL)isDetectingWithAlarm:(IAAlarm*)alarm;

@end
