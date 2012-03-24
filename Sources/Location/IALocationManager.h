//
//  YCLocationManager.h
//  iArrived
//
//  Created by li shiyong on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IALocationManagerInterface.h"
#import "IALocationManagerDelegate.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class IARegionsCenter;
//@class YCDistanceManager;
@interface IALocationManager : NSObject <CLLocationManagerDelegate,IALocationManagerInterface>
{
	BOOL canStart;
	
	BOOL standardLocationRuning;
	CLLocationManager *significantLocationManager;
	CLLocationManager *standardLocationManager;
	id<IALocationManagerDelegate> delegate;
	
	//CLLocation *lastMiddle;    //最后确定的有效“中等”精度坐标
	//CLLocation *lastHigh;      //最后确定的有效“高”精度坐标
	CLLocation *lastLocation;  //最后确定的坐标,任意精度
	

	UIBackgroundTaskIdentifier	bgTask;
	
	NSTimer	*foregroundLoopTimer;
	
	NSDate *standardLocationOpenTime; //标准定位打开持续时间，超过一定值后，轮询中就要关闭
	
	BOOL useUseLongLoopInterval;  //是否使用长轮询间隔
	NSTimeInterval loopInterval;  //轮询的时间间隔
	BOOL isShouldLoop;//是否应该轮询
	
    
    BOOL foregroundLooping;   //是否在轮询中
    BOOL backgroundLooping;   //是否在轮询中
    
    
    NSTimer	*checkDataBySignificantTimer;  //通过收到粗略定位触发，反复开启的标准定位的的Timer。
	NSDate *shouldStopCDSTimerTime;        //应该关闭checkDataBySignificantTimer的时间 
	
	NSTimer	*sendStandardLocationDidFinishTimer;  //发送定位通知的Timer。
	//BOOL isDidSendStandardLocationDidFinish;      //是否发送过通知
	
	NSInteger numberOfSeriesReceivesLowAccuracy;  //连续收到低精度数据的次数
	
	NSTimeInterval locatingInterval;  //定位的持续时间

	//debug 累计开启的时间
	NSTimeInterval sumOpenStandardLocation;
	
	NSDate *sendStandardLocationDidFinishNotificationTimestamp; //发送通知的时间戳
	

}
@property(nonatomic,readonly) BOOL canStart;
@property(nonatomic) BOOL standardLocationRuning;

@property(nonatomic,readonly) CLLocationManager *significantLocationManager;
@property(nonatomic,readonly) CLLocationManager *standardLocationManager;
@property(nonatomic,assign) id<IALocationManagerDelegate> delegate;
//@property(nonatomic,retain) CLLocation *lastMiddle;
//@property(nonatomic,retain) CLLocation *lastHigh;
@property(nonatomic,retain) CLLocation *lastLocation;


@property(nonatomic,retain) NSTimer	*foregroundLoopTimer;
@property(nonatomic,retain) NSDate *standardLocationOpenTime;

@property(assign,readonly) NSTimeInterval loopInterval;
@property(assign,readonly) BOOL isShouldLoop;



@property(nonatomic,retain) NSTimer	*checkDataBySignificantTimer;
@property(nonatomic,retain) NSDate *shouldStopCDSTimerTime;

@property(nonatomic,retain) NSTimer	*sendStandardLocationDidFinishTimer;

@property(nonatomic,assign,readonly) NSTimeInterval locatingInterval; 

@property(nonatomic,retain) NSDate *sendStandardLocationDidFinishNotificationTimestamp;


- (void)start;
- (void)stop;


//private
- (void)endLocationWithIsCheckLocationData:(BOOL)isCheckLocationData;
- (void)endLocationWithIsCheckLocationDataObj:(NSNumber*/*BOOL*/)isCheckLocationDataObj;
- (void)beginLocationWithDuration:(NSTimeInterval)duration IsCheckLocationData:(BOOL)isCheckLocationData;
- (void)beginLocationWithDurationObj:(NSNumber*/*NSTimeInterval*/)durationObj;
- (void)beginLocationDefault;

- (void)checkLocationData:(CLLocation*)locationData; 


//测试是否需要结束标准定位
- (void)testShouldStandardLocationRuning;


@end
