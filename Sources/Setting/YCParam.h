//
//  YCParam.h
//  iArrived
//
//  Created by li shiyong on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

enum {
	YCDeviceTypeIPhone = 0,
	YCDeviceTypeiPodTouch,
	YCDeviceTypeiPad,
	YCDeviceTypeUnKnown,
};
typedef NSUInteger YCDeviceType;


#define    klastLoadMapRegion                 @"lastLoadMapRegion"
#define    kunlock                            @"unlock"
@interface YCParam : NSObject <NSCoding> {
	
	MKCoordinateRegion lastLoadMapRegion;          //上一次使用地图的区域
	BOOL alertWhenCannotLocation;                  //不能收到有效的定位数据时候是否警告用户
	BOOL regionMonitoring;                         //是否使用区域监控,iphone4的功能
    BOOL leaveAlarmEnabled;                        //是否启用离开闹钟
}


@property (nonatomic,assign) MKCoordinateRegion lastLoadMapRegion;
@property (nonatomic,readonly) BOOL alertWhenCannotLocation;
@property (nonatomic,assign,readonly) BOOL isProUpgradePurchased;  //是否已经解锁
@property (nonatomic,assign,readonly) YCDeviceType deviceType;  
@property (nonatomic,assign,readonly) BOOL regionMonitoring;  
@property (nonatomic,assign,readonly) BOOL leaveAlarmEnabled;


+(YCParam*) paramSingleInstance;
-(void)saveParam;



@end
