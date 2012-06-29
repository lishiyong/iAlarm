//
//  YCLocationManager.m
//  iArrived
//
//  Created by li shiyong on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAGlobal.h"
#import "UIApplication+YC.h"
#import "IANotifications.h"
#import "IANotifications.h"
#import "YCDistanceManager.h"
#import "IAAlarm.h"
#import "YCSystemStatus.h"
#import "IARegion.h"
#import "IALocationManager.h"
#import "IARegionsCenter.h"
#import "YCParam.h"
#import "UIUtility.h"
#import "YCLog.h"


const NSTimeInterval kMaxStandardLocationThreshold = 1.5*60.0;                   //标准定位持续运行了多长时间，需要关闭的阀值
const NSTimeInterval kStandardLocationBySignificantLocationInterval = 4.0*60.0;  //通过粗略定位开启的标准定位的运行时间。

const NSTimeInterval kCheckDataBySignificantInterval = 8.0;                      //通过收到粗略定位触发，反复开启的标准定位的的间隔。

const NSTimeInterval kLoopInterval = 60.0;                                       //正常轮询间隔
const NSTimeInterval kLongLoopInterval = 550.0;                                  //长轮询间隔：当前位置在所有区域“预警区外”；或超过x分钟没有位置更新数据。

const NSTimeInterval kLocatingInterval = 29.0;                                   //定位的持续时间
const NSTimeInterval kShortLocatingInterval = 2.0;                               //短定位的持续时间




@implementation IALocationManager

@synthesize canStart;
@synthesize standardLocationRuning;
@synthesize delegate;
//@synthesize lastMiddle;
//@synthesize lastHigh;
@synthesize lastLocation;
@synthesize foregroundLoopTimer;
@synthesize standardLocationOpenTime;
@synthesize checkDataBySignificantTimer;
@synthesize shouldStopCDSTimerTime;
@synthesize sendStandardLocationDidFinishTimer;
@synthesize loopInterval;
@synthesize isShouldLoop;
@synthesize locatingInterval;
@synthesize sendStandardLocationDidFinishNotificationTimestamp;


//设置是否应该轮询
- (void)setIsShouldLooping:(CLLocation*)theLocation{
	
	if (theLocation == nil) {
		isShouldLoop = YES;
		return;
	}
	
	if ([[IARegionsCenter sharedRegionCenter].regions count] == 0) { //区域数目==0，需要轮询！
		//NSString *s = [NSString stringWithFormat:@"区域数目==0，不用轮询！"];
		//[[YCLog logSingleInstance] addlog:s];
		isShouldLoop =  NO;
		return;
	}
	
	if (theLocation.horizontalAccuracy > kLowAccuracyThreshold) { //精度太低，需要轮询
		isShouldLoop = YES;
		return;
	}
	
	
	NSInteger bigPreAlarmNumber = [[IARegionsCenter sharedRegionCenter ] numberOfContainsBigPreAlarmRegionsWithCoordinate:theLocation.coordinate];
	if (bigPreAlarmNumber == 0) {//不再任何一个大预警圈，停止轮询
		//NSString *s = [NSString stringWithFormat:@"不在任何一个大预警圈，不用轮询！"];
		//[[YCLog logSingleInstance] addlog:s];
		isShouldLoop =  NO;
		return;
	}
		
	isShouldLoop =  YES;
	
}

- (BOOL)isUsingLongLoopInterval:(CLLocation*)theLocation{
	
	if (theLocation == nil) {
		return NO;
	}
	
	if (theLocation.horizontalAccuracy > kLowAccuracyThreshold) { //精度太低
		return NO;
	}
	
	
	NSInteger innerNumber = [[IARegionsCenter sharedRegionCenter ] numberOfContainsRegionsWithCoordinate:theLocation.coordinate];
	NSInteger preAlarmNumber = [[IARegionsCenter sharedRegionCenter ] numberOfContainsPreAlarmRegionsWithCoordinate:theLocation.coordinate];
	
	//在所有区域的预警圈外
	if (0 == preAlarmNumber) {
		
		//NSString *s = [NSString stringWithFormat:@"在所有区域的预警圈外，启用长轮询间隔！"];
		//[[YCLog logSingleInstance] addlog:s];
		return YES;
		
	}else if(innerNumber >= preAlarmNumber ){
		//NSString *s = [NSString stringWithFormat:@"只是在某些区域中，启用长轮询间隔！"];
		//[[YCLog logSingleInstance] addlog:s];
		return YES;
	}
		
		
	return NO;
}

//设置轮询的间隔
- (void)setLoopInterval:(CLLocation*)theLocation{
    
	if ([self isUsingLongLoopInterval:theLocation]) {
		//NSString *s = [NSString stringWithFormat:@"取得轮询时间，%.1f",kLongLoopInterval];
		//[[YCLog logSingleInstance] addlog:s];
		
		loopInterval = kLongLoopInterval;
	}else{ 
		//NSString *s = [NSString stringWithFormat:@"取得轮询时间，%.1f",kLoopInterval];
		//[[YCLog logSingleInstance] addlog:s];
		
		loopInterval = kLoopInterval;
	}
}

/*
- (id)lastHigh{
	if (lastHigh) {
		NSTimeInterval ti = [lastHigh.timestamp timeIntervalSinceNow];
		ti = abs(ti);
		if (ti > 30.0) { //高精度数据，30秒内的才有效
			[lastHigh release];
			lastHigh = nil;
		}
	}
	
	return lastHigh;
}
 */

- (NSNumber*)numberYES{
    static NSNumber *objYES = nil;
	if (objYES == nil) {
		objYES = [[NSNumber numberWithBool:YES] retain];
	}
    return objYES;
}

- (NSNumber*)numberNO{
    static NSNumber *objNO = nil;
	if (objNO == nil) {
		objNO = [[NSNumber numberWithBool:NO] retain];
	}
    return objNO;
}

//是否应该在粗略定位中，打开标准定位
- (BOOL)isShouldStartStandardLocationWithSignificantLocationData:(CLLocation*)theLocation{
	
	if ([[IARegionsCenter sharedRegionCenter].regions count] == 0) { //区域数目==0，不用工作！
		//NSString *s = [NSString stringWithFormat:@"区域数目==0，不用工作！"];
		//[[YCLog logSingleInstance] addlog:s];
		return NO;
	}
	
    if (theLocation == nil) {//定位数据nil，需要工作！
        
        //NSString *s = [NSString stringWithFormat:@"定位数据nil，需要工作！"];
		//[[YCLog logSingleInstance] addlog:s];
        return YES;
    }
	
	if (theLocation.horizontalAccuracy > kLowAccuracyThreshold) { //精度太低，需要工作
		//NSString *s = [NSString stringWithFormat:@"精度太低，需要工作！"];
		//[[YCLog logSingleInstance] addlog:s];
		return YES;
	}
	
	NSInteger bigPreAlarmNumber = [[IARegionsCenter sharedRegionCenter ] containsBigPreAlarmRegionsWithCoordinate:theLocation.coordinate].count;
	if (bigPreAlarmNumber == 0) {  //不再任何一个大预警圈内，不用工作！

		//NSString *s = [NSString stringWithFormat:@"不再任何一个大预警圈内，不用工作！"];
		//[[YCLog logSingleInstance] addlog:s];
		return NO;
	}
	
	return YES;
	
}



-(CLLocationManager*)significantLocationManager
{
	if (significantLocationManager == nil) {
		significantLocationManager = [[CLLocationManager alloc] init];
		significantLocationManager.delegate = self;
	}
	return significantLocationManager;
}

-(CLLocationManager*)standardLocationManager
{
	if (standardLocationManager == nil) {
		standardLocationManager = [[CLLocationManager alloc] init];
		standardLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		//standardLocationManager.distanceFilter = 50.0;//移动小于50过滤掉
		standardLocationManager.delegate = self;
	}
	
	UIApplication* app = [UIApplication sharedApplication];
	if	(UIApplicationStateActive == app.applicationState)
		standardLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
	else 
		standardLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		
	return standardLocationManager;
}

#pragma mark -
#pragma mark utility

//停止前台轮询
- (void)stopForegroundLoopTimer{
	if (self.foregroundLoopTimer) {
		[self.foregroundLoopTimer invalidate];
		[self.foregroundLoopTimer release];
		foregroundLoopTimer = nil;
	}
	
	foregroundLooping = NO;
}

//停止粗略定位触发，反复开启的标准定位的的Timer。
- (void)stopCDSTimer{
	if (self.checkDataBySignificantTimer) 
	{
		[self.checkDataBySignificantTimer invalidate];
		[self.checkDataBySignificantTimer release];
		checkDataBySignificantTimer = nil;
		
		//[[YCLog logSingleInstance] addlog:@"停止粗略定位触发，反复开启的标准定位的的Timer"];
	}
}


- (void)sendStandardLocationDidFinishNotificationWithLocation:(CLLocation*)location{
	
    
    //////////////////////////////////////////////////////////////
    //发送接到定位数据通知
    NSDictionary *userInfo = nil;
    if (location)
        userInfo = [NSDictionary dictionaryWithObject:location forKey:IAStandardLocationKey];
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAStandardLocationDidFinishNotification 
                                                                  object:self 
                                                                userInfo:userInfo];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    //////////////////////////////////////////////////////////////
	self.sendStandardLocationDidFinishNotificationTimestamp = [NSDate date];
	//isDidSendStandardLocationDidFinish = YES;
}

- (void)beginLocationWithDuration:(NSTimeInterval)duration IsCheckLocationData:(BOOL)isCheckLocationData{
	
	if (YES == standardLocationRuning) {  
		//[[YCLog logSingleInstance] addlog:@"标准定位已经开启，无需重复开启！"];
		return;
	}
	
    
	//打开标准定位
	self.lastLocation = nil;
	[self.standardLocationManager startUpdatingLocation];
	self.standardLocationRuning = YES;
	self.standardLocationOpenTime = [NSDate date]; // 打开的时间 ＝now
	//[[YCLog logSingleInstance] addlog:@"开启了标准定位！"];
	
	NSNumber *b = isCheckLocationData?[self numberYES]:[self numberNO];
	//预约关闭时间
	[self performSelector:@selector(endLocationWithIsCheckLocationDataObj:) withObject:b afterDelay:duration];
	
	//NSString *s = [NSString stringWithFormat:@"预约关闭时间 = %@",[[[NSDate dateWithTimeIntervalSinceNow:duration] description] substringToIndex:19]];
	//[[YCLog logSingleInstance] addlog:s];
	
	
}

- (void)beginLocationWithDurationObj:(NSNumber*/*NSTimeInterval*/)durationObj{
	NSTimeInterval ti = self.locatingInterval;
	if (durationObj) ti = [durationObj doubleValue];

	[self beginLocationWithDuration:ti IsCheckLocationData:YES];
}

- (void)beginLocationDefault{
	//[[YCLog logSingleInstance] addlog:@"beginLocationDefault,在后台就是粗略定位轮询引发的！"];
	[self beginLocationWithDuration:self.locatingInterval IsCheckLocationData:YES];
}

//endLocation的延后部分,为了关闭标准定位时候还能收到一次定位数据
- (void)endLocationDelaySectionWithIsCheckLocationDataObj:(NSNumber*/*BOOL*/)isCheckLocationDataObj{

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endLocationDelaySectionWithIsCheckLocationDataObj:) object:isCheckLocationDataObj];

	//在这个地方cancle endLocationWithIsCheckLocationDataObj:，是为了cancel stop定位后，收到最后一次定位数据引发的调用。
	//[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endLocationWithIsCheckLocationDataObj:) object:isCheckLocationDataObj];

	
	BOOL isCheckLocationData = [isCheckLocationDataObj boolValue];
	UIApplication* app = [UIApplication sharedApplication];
	
	//测试一下checkDataBySignificantTimer 是否需要停止
	if (self.checkDataBySignificantTimer){ 
		
		NSInteger regionsCount = [[IARegionsCenter sharedRegionCenter].regions count];//区域==0
		BOOL shouldStop = ([self.shouldStopCDSTimerTime compare:[NSDate date]] == NSOrderedAscending); //时间到了
		if (self.shouldStopCDSTimerTime == nil) //防止有错
			shouldStop = YES;
		
		
		BOOL shouldWork = YES;
		if (self.lastLocation.horizontalAccuracy < kMiddleAccuracyThreshold) //精度要xx，才能检测这项
			shouldWork = [self isShouldStartStandardLocationWithSignificantLocationData:self.lastLocation]; //距离远了
		
		if (regionsCount == 0) {
			[self stopCDSTimer]; 
			//NSString *s = [NSString stringWithFormat:@"停止了粗略定位引发的轮询，区域==0!"];
			//[[YCLog logSingleInstance] addlog:s];
			
		}else if (shouldStop) {
			
			[self stopCDSTimer]; 
			//NSString *s = [NSString stringWithFormat:@"停止了粗略定位引发的轮询，时间到了！"];
			//[[YCLog logSingleInstance] addlog:s];
			
		}else if (!shouldWork){
			
			[self stopCDSTimer];  
			//NSString *s = [NSString stringWithFormat:@"停止了粗略定位引发的轮询，距离远了！",shouldWork,shouldStop];
			//[[YCLog logSingleInstance] addlog:s];
			
		}
		
	}
	
	
	//测试 是否需要停止轮询
	[self setIsShouldLooping:self.lastLocation];
	if (self->isShouldLoop) {//需要轮询才设置轮询时间
		[self setLoopInterval:self.lastLocation];
	}else {
		self->loopInterval = kLoopInterval;
	}
	
	
	//如果在前台，需要在这里结束轮询
	if (UIApplicationStateActive == app.applicationState && !self.isShouldLoop) {
		[self stopForegroundLoopTimer];
	}
	
	
	
	//检查数据
	NSInteger regionCount = [[IARegionsCenter sharedRegionCenter].regions count];
	if (isCheckLocationData && regionCount > 0) { //区域数目大于0才检查数据
		
		if (self.lastLocation != nil){
			[self checkLocationData:self.lastLocation];
		}else {
			[self performSelector:@selector(beginLocationWithDurationObj:) withObject:[NSNumber numberWithDouble:self.locatingInterval] afterDelay:10.0];
			//NSString *s = [NSString stringWithFormat:@"定位数据 == nil，10秒后重开标准定位"];
			//[[YCLog logSingleInstance] addlog:s];
		}
		
	}
	
	//连续多次收到低精度数据，缩短持续定位的时间。--没必要浪费电
	if (!self.lastLocation || self.lastLocation.horizontalAccuracy > kLowAccuracyThreshold) {
		numberOfSeriesReceivesLowAccuracy ++;
	}else {
		numberOfSeriesReceivesLowAccuracy = 0;
		self->locatingInterval = kLocatingInterval;
		//[[YCLog logSingleInstance] addlog:@"由于取得了一次高精度数据，恢复为长定位时间"];
	}
	
	if (numberOfSeriesReceivesLowAccuracy > 10) {
		self->locatingInterval = kShortLocatingInterval;
		//[[YCLog logSingleInstance] addlog:@"由于连续10次无高精度数据，用短定位时间"];
	}
	
	

}

- (void)endLocationWithIsCheckLocationData:(BOOL)isCheckLocationData{
	
	
	/*
	//debug
	sumOpenStandardLocation += (-[self.standardLocationOpenTime timeIntervalSinceNow]);
	NSString *s = [NSString stringWithFormat:@"标准定位累计开启了 %.1f秒！",sumOpenStandardLocation];
	[[YCLog logSingleInstance] addlog:s];
	//debug
	 */
	
	[self.standardLocationManager stopUpdatingLocation];
	self.standardLocationRuning = NO;
	self.standardLocationOpenTime = nil;
	//[[YCLog logSingleInstance] addlog:@"标准定位已经关闭！"];
	
	//延时执行后背部分，为了收到最后一次定位数据
	[self performSelector:@selector(endLocationDelaySectionWithIsCheckLocationDataObj:) withObject:(isCheckLocationData ? [self numberYES]:[self numberNO]) afterDelay:1.0];
	
	
	/*
	UIApplication* app = [UIApplication sharedApplication];
	//测试一下checkDataBySignificantTimer 是否需要停止
	if (self.checkDataBySignificantTimer){ 
		
		NSInteger regionsCount = [[IARegionsCenter regionCenterSingleInstance].regions count];//区域==0
		BOOL shouldStop = ([self.shouldStopCDSTimerTime compare:[NSDate date]] == NSOrderedAscending); //时间到了
		if (self.shouldStopCDSTimerTime == nil) //防止有错
			shouldStop = YES;
		
		
		BOOL shouldWork = YES;
		if (self.lastLocation.horizontalAccuracy < kMiddleAccuracyThreshold) //精度要xx，才能检测这项
			shouldWork = [self isShouldStartStandardLocationWithSignificantLocationData:self.lastLocation]; //距离远了
		
		if (regionsCount == 0) {
			[self stopCDSTimer]; 
			//NSString *s = [NSString stringWithFormat:@"停止了粗略定位引发的轮询，区域==0!"];
			//[[YCLog logSingleInstance] addlog:s];
			
		}else if (shouldStop) {
			
			[self stopCDSTimer]; 
			//NSString *s = [NSString stringWithFormat:@"停止了粗略定位引发的轮询，时间到了！"];
			//[[YCLog logSingleInstance] addlog:s];
			
		}else if (!shouldWork){
			
			[self stopCDSTimer];  
			//NSString *s = [NSString stringWithFormat:@"停止了粗略定位引发的轮询，距离远了！",shouldWork,shouldStop];
			//[[YCLog logSingleInstance] addlog:s];
			
		}
		
	}
	
	
	//测试 是否需要停止轮询
	[self setIsShouldLooping:self.lastLocation];
	if (self->isShouldLoop) {//需要轮询才设置轮询时间
		[self setLoopInterval:self.lastLocation];
	}else {
		self->loopInterval = kLoopInterval;
	}
	

	//如果在前台，需要在这里结束轮询
	if (UIApplicationStateActive == app.applicationState && !self.isShouldLoop) {
		[self stopForegroundLoop];
	}
	
		

	//检查数据
	NSInteger regionCount = [[IARegionsCenter regionCenterSingleInstance].regions count];
	if (isCheckLocationData && regionCount > 0) { //区域数目大于0才检查数据
		
		if (self.lastLocation != nil){
			[self checkLocationData:self.lastLocation];
		}else {
			[self performSelector:@selector(beginLocationWithDurationObj:) withObject:[NSNumber numberWithDouble:self.locatingInterval] afterDelay:10.0];
			//NSString *s = [NSString stringWithFormat:@"定位数据 == nil，10秒后重开标准定位"];
			//[[YCLog logSingleInstance] addlog:s];
		}
		
	}
	
	//连续多次收到低精度数据，缩短持续定位的时间。--没必要浪费电
	if (!self.lastLocation || self.lastLocation.horizontalAccuracy > kLowAccuracyThreshold) {
		numberOfSeriesReceivesLowAccuracy ++;
	}else {
		numberOfSeriesReceivesLowAccuracy = 0;
		self->locatingInterval = kLocatingInterval;
		//[[YCLog logSingleInstance] addlog:@"由于取得了一次高精度数据，恢复为长定位时间"];
	}

	if (numberOfSeriesReceivesLowAccuracy > 10) {
		self->locatingInterval = kShortLocatingInterval;
		//[[YCLog logSingleInstance] addlog:@"由于连续10次无高精度数据，用短定位时间"];
	}
	 
	*/
	
	
}

- (void)endLocationWithIsCheckLocationDataObj:(NSNumber*/*BOOL*/)isCheckLocationDataObj{
	//[[YCLog logSingleInstance] addlog:@"call endLocationWithIsCheckLocationDataObj"];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endLocationWithIsCheckLocationDataObj:) object:isCheckLocationDataObj];
	BOOL b = [isCheckLocationDataObj boolValue];
    [self endLocationWithIsCheckLocationData:b];
}


- (void)checkLocationData:(CLLocation*)locationData{
	
    //[[YCLog logSingleInstance] addlog:@"分析定位数据..."];//TODO delete
	
	//NSString *ss0 = [NSString stringWithFormat:@"locationData.timestamp = %@",[[locationData.timestamp description] substringToIndex:19]];
	//[[YCLog logSingleInstance] addlog:ss0];
	
	BOOL canChange = [[IARegionsCenter sharedRegionCenter] canChangeUserLocationTypeForCoordinate:locationData.coordinate];
	if (canChange) { //定位数据能改变某个区域的状态
					
		//调用代理
		IARegionsCenter *regionsCenter = [IARegionsCenter sharedRegionCenter];
		
		for (IARegion *region in regionsCenter.regionArray) {
			IAUserLocationType currentType = [region containsCoordinate:locationData.coordinate];
			/*
			CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:region.region.center.latitude longitude:region.region.center.longitude] autorelease];
			CLLocationDistance d = [locationData distanceFromLocation:aLocation];
			NSString *s0 = [NSString stringWithFormat:@"调用－－ %@ Type = %d 距离当前距离 = %.1fm 半径 = %.1f",region.alarm.alarmName ,currentType,d,region.region.radius];
			[[YCLog logSingleInstance] addlog:s0];//TODO delete
			 */
			
			if (locationData.horizontalAccuracy > kMiddleAccuracyThreshold) {
				if (region.region.radius < kRadiusAccuracyRateWhenLowAccuracyThreshold * locationData.horizontalAccuracy) {
					//[[YCLog logSingleInstance] addlog:@"精度太低 而 半径又较小，不能确认是否到达！"];
					continue;
				}
			}

			if (currentType != region.userLocationType) {
				
				if (IAUserLocationTypeInner == currentType){
					
					[self.delegate locationManager:self didEnterRegion:region];
					region.userLocationType = currentType;
					
					NSString *s = [NSString stringWithFormat:@"进入区域，名称：%@，精度：%.1f",region.alarm.alarmName,self.lastLocation.horizontalAccuracy];
					[[YCLog logSingleInstance] addlog:s];
					
				}else if(IAUserLocationTypeOuter == currentType){
					
					[self.delegate locationManager:self didExitRegion:region];
					region.userLocationType = currentType;
					
					NSString *s = [NSString stringWithFormat:@"走出区域，名称：%@，精度：%.1f",region.alarm.alarmName,self.lastLocation.horizontalAccuracy];
					[[YCLog logSingleInstance] addlog:s];
					
				}else {
					//不处理边缘情况
					//region.userLocationType = IAUserLocationTypeOuter; //防止以外产生的边缘类型
				}
				
				
			}
			
		}//end for
		
	}
		
	
}




//测试是否因为运行时间过长，因而需要结束标准定位
- (void)testShouldStandardLocationRuning{
	if (self.standardLocationOpenTime) {
        NSTimeInterval duration = abs([self.standardLocationOpenTime timeIntervalSinceNow]);
        if (duration > kMaxStandardLocationThreshold) {
            [self endLocationWithIsCheckLocationData:YES]; //已经持续开了x分钟了，关闭
            //[[YCLog logSingleInstance] addlog:@"标准定位已经持续超过x分钟，关闭！"];
        }
    }
}
 



- (void)foregroundTask{
	//[[YCLog logSingleInstance] addlog:@"前台任务轮询..."];
	
	[self beginLocationDefault];
	[self testShouldStandardLocationRuning];//测试 标准定位运行时间。持续时间长就关闭
	
	
	//前台任务啥时候应该结束，在endLocation函数中处理
	
}



-(void)backgroundBask{
	    
	//[[YCLog logSingleInstance] addlog:@"后台任务已经开启！"];
    
    backgroundLooping = YES;
	
	[NSThread sleepForTimeInterval:10.0];//xx秒后在定夺生死
	
    UIApplication* app = [UIApplication sharedApplication];
	while (UIApplicationStateBackground == app.applicationState && self->isShouldLoop) {
		
		//[[YCLog logSingleInstance] addlog:@"后台任务轮询..."];//TODO delete
		
		/*
		[NSThread sleepForTimeInterval:(self.loopInterval/2)];
        
		[self performSelectorOnMainThread:@selector(beginLocationDefault) withObject:nil waitUntilDone:NO];
				
		[NSThread sleepForTimeInterval:(self.loopInterval/2)]; 
		
		//测试 标准定位运行时间。持续时间长就关闭
		[self performSelectorOnMainThread:@selector(testShouldStandardLocationRuning) withObject:nil waitUntilDone:NO];
		 */
		    

		[self performSelectorOnMainThread:@selector(beginLocationDefault) withObject:nil waitUntilDone:NO];
		
		[NSThread sleepForTimeInterval:(self.loopInterval)]; 
		
		//测试 标准定位运行时间。持续时间长就关闭
		[self performSelectorOnMainThread:@selector(testShouldStandardLocationRuning) withObject:nil waitUntilDone:NO];
		
	} 
	
    backgroundLooping = NO;
    
    if (UIApplicationStateBackground == app.applicationState) {

		//都没有循环了，标准定位也没用了
		[self performSelectorOnMainThread:@selector(endLocationWithIsCheckLocationDataObj:) withObject:[self numberNO] waitUntilDone:NO];
		//都没有循环了，这个反复开启也没用了
		[self performSelectorOnMainThread:@selector(stopCDSTimer) withObject:nil waitUntilDone:NO];
	}
    
    
	//[[YCLog logSingleInstance] addlog:@"后台任务已经结束！"];
	

}

- (void)startBackgroundBask{
	
	
	
	UIApplication *app = [UIApplication sharedApplication];
	
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
	
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
        // Do the work associated with the task.
		[self backgroundBask];
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
	 
	 	
}





#pragma mark -
#pragma mark Notification

- (void) handle_applicationDidEnterBackground:(id) notification{
	
	[self stopForegroundLoopTimer]; //停止前台轮询
	
	if (!canStart) return;
	
	[self beginLocationDefault]; //先执行一次。以后靠轮询了。
	if ([[IARegionsCenter sharedRegionCenter].regions count] != 0)
    {
		if (UIBackgroundTaskInvalid == bgTask) {
			[self startBackgroundBask];	 
		}
	}else {
		//[[YCLog logSingleInstance] addlog:@"区域数量 = 0,不启动后台轮询"];
	}


	///////// debug
	//[self invokeSig];
	//[self performSelector:@selector(invokeSig) withObject:nil afterDelay:120.0];
}

- (void)handle_applicationWillEnterForeground_DidFinishLaunching:(NSNotification*)notification {
	
	if (!canStart) return;
	
	if (self.foregroundLoopTimer == nil) {

		
		if ([[IARegionsCenter sharedRegionCenter].regions count] != 0)
		{
			[self beginLocationWithDuration:15.0 IsCheckLocationData:YES]; //先执行一次。以后靠轮询了。
			
			NSTimeInterval ti = self.loopInterval;
			self.foregroundLoopTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(foregroundTask) userInfo:nil repeats:YES];
			
			foregroundLooping = YES;
			//NSString *s = [NSString stringWithFormat:@"启动前台轮询，间隔： %.1f",ti];
			//[[YCLog logSingleInstance] addlog:s];
		}else {
			//[[YCLog logSingleInstance] addlog:@"区域数量 = 0,不启动前台轮询"];
			if (NO == standardLocationRuning) 
				[self beginLocationWithDuration:15.0 IsCheckLocationData:NO]; //为了显示不能定位图标
				
		}

	}
	
}

- (void)handle_applicationDidBecomeActive:(NSNotification*)notification {
	
    //对应于 失去活动时停止了定位
    [self start];
    
	
    if (self.sendStandardLocationDidFinishTimer == nil) {
		self.sendStandardLocationDidFinishTimer = [NSTimer scheduledTimerWithTimeInterval:70.0 target:self selector:@selector(beginLocationDefault) userInfo:nil repeats:YES];
		//[[YCLog logSingleInstance] addlog:@"启动了发送通知轮询"];
	}
	[self beginLocationDefault];//以后靠轮询
	
	self.sendStandardLocationDidFinishNotificationTimestamp = nil;//为了马上能判断是否发通知
	
	
}

- (void) handle_applicationWillResignActive:(id)notification{	
	[self.sendStandardLocationDidFinishTimer invalidate];
	[self.sendStandardLocationDidFinishTimer release];
	sendStandardLocationDidFinishTimer = nil;
	
	//isDidSendStandardLocationDidFinish = NO; //为了让下次激活、不能定位时候发送通知
	
	//免得下次使用了缓存
	[YCSystemStatus sharedSystemStatus].lastLocation = nil;
	
	//[[YCLog logSingleInstance] addlog:@"关闭了发送通知轮询"];
    
    //没有有效的闹钟，不需要开启任何定位
    if ([IARegionsCenter sharedRegionCenter].regions.count == 0) {
        [self stop];
    }
}

- (void) handle_regionsDidChange:(id)notification {
	UIApplication* app = [UIApplication sharedApplication];
	
	if (UIApplicationStateBackground == app.applicationState){
		[self handle_applicationDidEnterBackground:nil];
	}else {
        [self beginLocationWithDuration:15.0 IsCheckLocationData:YES]; //先执行一次。轮询可能可能在需要等。
		[self handle_applicationWillEnterForeground_DidFinishLaunching:nil];
	}
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqualToString:@"standardLocationRuning"]){
       BOOL s = [(NSNumber*)[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        NSLog(@"standardLocationRuning = %d , %d ",self.standardLocationRuning,s);
    }
	
}
 */

- (void) registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handle_regionsDidChange:)
							   name: IARegionsDidChangeNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidEnterBackground:)
							   name: UIApplicationDidEnterBackgroundNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground_DidFinishLaunching:)
							   name: UIApplicationWillEnterForegroundNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground_DidFinishLaunching:)
							   name: UIApplicationDidFinishLaunchingNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidBecomeActive:)
							   name: UIApplicationDidBecomeActiveNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
    
    //[self addObserver:self forKeyPath:@"standardLocationRuning" options:NSKeyValueObservingOptionNew context:nil];
    
	 
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IARegionsDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillEnterForegroundNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidFinishLaunchingNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidBecomeActiveNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}

#pragma mark - 
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{	
	
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) > 5.0) {
		//NSString *s = [NSString stringWithFormat:@"缓存数据 %.1f，丢弃！",howRecent];
		//[[YCLog logSingleInstance] addlog:s];
		return;
	}
	

    //////////////////////////////////////////////////////////////
    //程序在前台，发送接到定位数据通知
    UIApplication* app = [UIApplication sharedApplication];
	if	(UIApplicationStateActive == app.applicationState){
		

        /*
        NSTimeInterval ti = 31.0;
        if (self.sendStandardLocationDidFinishNotificationTimestamp) {
            ti = [[NSDate date] timeIntervalSinceDate:self.sendStandardLocationDidFinishNotificationTimestamp];
        }
         
        
		
		/////////////////
		BOOL isShouldSend = (ti >10.0) ;//定位间隔小于30秒,不发通知
		
		BOOL isCanVaildLocation = ( (app.applicationDidFinishLaunchineTimeElapsing < 90.0) || [[IARegionsCenter regionCenterSingleInstance] canDetermineDistanceFromLocation:newLocation]);
		                          //程序刚刚启动不久，容忍任何低精度数据                              
		
		isShouldSend = ( isShouldSend || (isCanVaildLocation != [YCSystemStatus deviceStatusSingleInstance].canValidLocation) ); //与上次状态相反一定发送
		
		
		if (isShouldSend) {
			CLLocation *sendLocation = isCanVaildLocation ? newLocation : nil;
			[YCSystemStatus deviceStatusSingleInstance].lastLocation = sendLocation;//收集last数据
			[self performSelector:@selector(sendStandardLocationDidFinishNotificationWithLocation:) withObject:sendLocation afterDelay:0.0];
		}
         */
        
        [YCSystemStatus sharedSystemStatus].lastLocation = newLocation;//收集last数据
        [self sendStandardLocationDidFinishNotificationWithLocation:newLocation];
		
        
    }
    //////////////////////////////////////////////////////////////
	 
    
	
	//粗略定位
	if (manager == self.significantLocationManager) {
		
		[[YCLog logSingleInstance] addlog:@"收到粗略定位数据！"];
		
		double distance = 0.0;
		NSString *message = @"粗略定位 oldLocation is nil!";
		if (oldLocation) {			
			distance = [newLocation distanceFromLocation:oldLocation];
			message = [NSString stringWithFormat:@"粗略定位 与上次距离:%.1f",distance];
		}
		[[YCLog logSingleInstance] addlog:message];
		
		
		if ([self isShouldStartStandardLocationWithSignificantLocationData:newLocation] && [self canStart]) {
			
			[self stopCDSTimer];//先给停止了
			self.checkDataBySignificantTimer = [NSTimer scheduledTimerWithTimeInterval:kCheckDataBySignificantInterval target:self selector:@selector(beginLocationDefault) userInfo:nil repeats:YES];
			
			//关闭timer的时间
			self.shouldStopCDSTimerTime = [NSDate dateWithTimeIntervalSinceNow:kStandardLocationBySignificantLocationInterval]; 
			
			//先启动一次，以后靠轮询
			[self performSelector:@selector(beginLocationDefault) withObject:nil afterDelay:0.0];
			
			[[YCLog logSingleInstance] addlog:@"通过粗略定位通知，开启了标准定位！"];
			
            
            UIApplication* app = [UIApplication sharedApplication];
			if (UIApplicationStateBackground == app.applicationState){//后台
                //是否正在轮询 
                if (!backgroundLooping) {//在后台，启动了标准定位就需要启动轮询，否则无法使用timer
                    if (UIBackgroundTaskInvalid == bgTask) {
                        [self startBackgroundBask];	 //启动轮询
                    }
                }
			}
            
		}
		
		return;
		
	}
	
	//NSString *s = [NSString stringWithFormat:@" 收到定位数据，精度：%.1f！",newLocation.horizontalAccuracy];
	//[[YCLog logSingleInstance] addlog:s];//TODO delete

	
	
	//采集数据
	if (self.lastLocation == nil || self.lastLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
		self.lastLocation = newLocation;
		
		if (standardLocationRuning && newLocation.horizontalAccuracy <= kCLLocationAccuracyHundredMeters) //百米精度足以，不用浪费时间
		{
			//NSString *s = [NSString stringWithFormat:@"取得了百米以下精度数据 = %.1f，结束标准定位！",newLocation.horizontalAccuracy];
			//[[YCLog logSingleInstance] addlog:s];
			//[self endLocationWithIsCheckLocationData:YES];
			[self performSelector:@selector(endLocationWithIsCheckLocationDataObj:) withObject:[self numberYES] afterDelay:0.1];
			return;
			
		}
		
		if (standardLocationRuning && newLocation.horizontalAccuracy <= kHighAccuracyThreshold) //高精度精度
		{
			//NSString *s = [NSString stringWithFormat:@"取得了高精度数据 = %.1f，1秒后结束标准定位！",newLocation.horizontalAccuracy];
			//[[YCLog logSingleInstance] addlog:s];
			[self performSelector:@selector(endLocationWithIsCheckLocationDataObj:) withObject:[self numberYES] afterDelay:1.0];
			return;
		}
		
		
		if (standardLocationRuning && newLocation.horizontalAccuracy <= kMiddleAccuracyThreshold) //中等精度
		{
			//NSString *s = [NSString stringWithFormat:@"取得了中等精度数据 = %.1f，2秒后结束标准定位！",newLocation.horizontalAccuracy];
			//[[YCLog logSingleInstance] addlog:s];
			[self performSelector:@selector(endLocationWithIsCheckLocationDataObj:) withObject:[self numberYES] afterDelay:2.0];
			return;
		}
		
		if (standardLocationRuning && newLocation.horizontalAccuracy <= kLowAccuracyThreshold) //低等精度
		{
			//NSString *s = [NSString stringWithFormat:@"取得了中等精度数据 = %.1f，5秒后结束标准定位！",newLocation.horizontalAccuracy];
			//[[YCLog logSingleInstance] addlog:s];
			[self performSelector:@selector(endLocationWithIsCheckLocationDataObj:) withObject:[self numberYES] afterDelay:5.0];
			return;
		}
		
	}
	

}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	//NSString *s = [NSString stringWithFormat:@"significantManager didFailWithError %@",error];
	//[[YCLog logSingleInstance] addlog:s];
    
    [YCSystemStatus sharedSystemStatus].lastLocation = nil;
	
	//////////////////////////////////////////////////////////////
    //程序在前台，发送接到定位数据通知
    UIApplication* app = [UIApplication sharedApplication];
	if	(UIApplicationStateActive == app.applicationState){
		[self sendStandardLocationDidFinishNotificationWithLocation:nil];
    }
    //////////////////////////////////////////////////////////////
	
	//结束定位
	[self endLocationWithIsCheckLocationData: NO];

}



- (id)init{
    self = [super init];
	if (self) {
		[self registerNotifications];
		//distanceManager =[[YCDistanceManager alloc] init];
        //canAddLocationCuration = YES;
		self->isShouldLoop = YES;
		self->loopInterval = kLoopInterval;
		self->numberOfSeriesReceivesLowAccuracy = 0;
		self->locatingInterval = kLocatingInterval;
	}
	return self;
}


- (void)start{
	canStart = YES;
    [self.significantLocationManager startMonitoringSignificantLocationChanges];
}
- (void)stop{
	canStart = NO;
	[self.significantLocationManager stopMonitoringSignificantLocationChanges];
	[self.standardLocationManager stopUpdatingLocation];
	self.standardLocationRuning = NO;
}


-(void) dealloc
{
    [significantLocationManager stopMonitoringSignificantLocationChanges];
    [standardLocationManager startUpdatingLocation];
    
	[self unRegisterNotifications];
	[significantLocationManager release];
	[standardLocationManager release];
	//[lastMiddle release];
	[foregroundLoopTimer release];
	
	[standardLocationOpenTime release];
	[lastLocation release];
    [checkDataBySignificantTimer release];
	[shouldStopCDSTimerTime release];
	[sendStandardLocationDidFinishTimer release];
	[sendStandardLocationDidFinishNotificationTimestamp release];

	[super dealloc];
}


- (void)invokeSig{
	CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:41.77060836 longitude:123.38654977] autorelease];
	[self locationManager:self.significantLocationManager didUpdateToLocation:aLocation fromLocation:nil];
}

@end
