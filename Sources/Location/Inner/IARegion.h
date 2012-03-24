//
//  IARegion.h
//  iAlarm
//
//  Created by li shiyong on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>



enum {
    IAUserLocationTypeInner = 0,       
	IAUserLocationTypeOuter,           
    IAUserLocationTypeEdge           //用户持有的设备在区域边缘，边缘宽度，占区域半径的10％
};
typedef NSUInteger IAUserLocationType;

@class IAAlarm;
@class CLRegion;
@interface IARegion : NSObject {
	IAAlarm *alarm;
	CLRegion *region;
	IAUserLocationType userLocationType;
	
	//先创建好，不用每次都创建，节电
	CLRegion *regionInner;
	CLRegion *regionOuter;
	CLRegion *preAlarmRegion;
	CLRegion *bigPreAlarmRegion; 
	
	CLLocation *location;
	
    //BOOL userLocationTypeUpdated; //是否被更新过
}

@property (nonatomic,retain,readonly) IAAlarm *alarm;
@property (nonatomic,retain,readonly) CLRegion *region;
@property (nonatomic,assign) IAUserLocationType userLocationType;

@property (nonatomic,retain,readonly) CLRegion *regionInner;
@property (nonatomic,retain,readonly) CLRegion *regionOuter;
@property (nonatomic,retain,readonly) CLRegion *preAlarmRegion;
@property (nonatomic,retain,readonly) CLRegion *bigPreAlarmRegion;

@property (nonatomic,retain,readonly) CLLocation *location;

- (IAUserLocationType)containsCoordinate:(CLLocationCoordinate2D)coodinate;

- (CLLocationDistance)distanceFromLocation:(const CLLocation *)theLocation;

//正在运行中：到达时候提醒 且 类型 == IAUserLocationTypeOuter ; 离开时候提醒 且 类型 == IAUserLocationTypeInner
- (BOOL)isDetecting;

- (id)initWithAlarm:(IAAlarm*)theAlarm currentLocation:(CLLocation*)currentLocation;



@property (nonatomic,readonly)CLLocationAccuracy monitoringForRegionDesiredAccuracy;


@end
