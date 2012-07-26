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

@class IARegion;

@interface IARegionsCenter : NSObject {
	NSMutableDictionary *_regions;      //所有需要监控的区域
}

@property(nonatomic,readonly)NSDictionary *regions;

- (void)addRegion:(IARegion*)region;
- (void)addRegions:(NSArray*)regions;
- (void)removeRegion:(IARegion*)region;
- (void)removeRegions:(NSArray*)regions;

//坐标是否能引起列表中的区域类型发生改变
- (BOOL)canChangeUserLocationTypeForCoordinate:(CLLocationCoordinate2D)coordinate;

//检测列表，把不应该运行的region清理掉
- (void)checkRegionsForRemove;

//检测所有闹钟，把符合条件的加入到列表中
- (NSArray*)checkAlarmsForAdd;


+ (IARegionsCenter*)sharedRegionCenter;



@end
