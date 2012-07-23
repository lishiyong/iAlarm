//
//  RegionCenter.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAAlarmCalendar.h"
#import "YCSound.h"
#import "YCLib.h"
#import "IAGlobal.h"
#import "YCLog.h"
#import "YCSystemStatus.h"
#import "IASaveInfo.h"
#import "IARegion.h"
#import "IAAlarm.h"
#import "IARegionsCenter.h"

//区域列表改变，包括：增，改，删
NSString *IARegionsDidChangeNotification = @"IARegionsDidChangeNotification";
NSString *IARegionKey = @"IARegionKey";

@implementation IARegionsCenter

@synthesize regionArray;

-(NSDictionary*)regions
{
	if (regions == nil) {
		regions = [[NSMutableDictionary alloc] init];
	}
	
	return regions;
}

-(NSDictionary*)allRegions
{
	if (allRegions == nil) {
		allRegions = [[NSMutableDictionary alloc] init];
	}
	
	return allRegions;
}

- (void)addRegion:(IARegion*)region{
    [(NSMutableDictionary*)self.regions setObject:region forKey:region.alarm.alarmId];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IARegionsDidChangeNotification 
                                                                  object:self 
                                                                userInfo:nil];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    CLLocation *lastLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
    
    //生成allRegions
	NSMutableDictionary* theAllRegions = (NSMutableDictionary*)self.allRegions;	
	[theAllRegions removeAllObjects];
	for (IAAlarm *oneAlarm in [IAAlarm alarmArray]) {
		IARegion *region = [[[IARegion alloc] initWithAlarm:oneAlarm currentLocation:lastLocation] autorelease];
		[theAllRegions setObject:region forKey:oneAlarm.alarmId];
	}
    
    //生成数组
	[self genRegionArray];
    
}

- (void)removeRegion:(IARegion*)region{
    [(NSMutableDictionary*)self.regions removeObjectForKey:region.alarm.alarmId];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IARegionsDidChangeNotification 
                                                                  object:self 
                                                                userInfo:nil];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    
    CLLocation *lastLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
    //生成allRegions
	NSMutableDictionary* theAllRegions = (NSMutableDictionary*)self.allRegions;	
	[theAllRegions removeAllObjects];
	for (IAAlarm *oneAlarm in [IAAlarm alarmArray]) {
		IARegion *region = [[[IARegion alloc] initWithAlarm:oneAlarm currentLocation:lastLocation] autorelease];
		[theAllRegions setObject:region forKey:oneAlarm.alarmId];
	}
    
    //生成数组
	[self genRegionArray];

}


#pragma mark -
#pragma mark uitilty

//生成数组
- (void)genRegionArray{
	[regionArray release];
    regionArray = [[self.regions allValues] retain];
	
	[allRegionArray release];
	allRegionArray = [[self.allRegions allValues] retain];
}


#pragma mark -
#pragma mark Notification



//闹钟列表发生变化
- (void) handle_alarmsDataListDidChange:(id)notification {
	
    CLLocation *lastLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
    
    IARegion *region = nil;
    IAAlarm *alarm = nil;
	IASaveInfo *saveInfo = [((NSNotification*)notification).userInfo objectForKey:IASaveInfoKey];
	if (saveInfo) {
		
		if (IASaveTypeUpdate == saveInfo.saveType) {
			
            alarm = [IAAlarm findForAlarmId:saveInfo.objId];
            region = [[[IARegion alloc] initWithAlarm:alarm currentLocation:lastLocation] autorelease];
            
            //先删除
            //[self->regions removeObjectForKey:saveInfo.objId];
			[self removeRegion:region];
            //再增加
            if (alarm.shouldWorking) {//判断是否启用
				//[(NSMutableDictionary*)self.regions setObject:region forKey:saveInfo.objId];
                [self addRegion:region];
			}
			
		}else if(IASaveTypeAdd == saveInfo.saveType){
			
			//增加
			alarm = [IAAlarm findForAlarmId:saveInfo.objId];
            region = [[[IARegion alloc] initWithAlarm:alarm currentLocation:lastLocation] autorelease];
			if (alarm.shouldWorking) {//判断是否启用
				//[(NSMutableDictionary*)self.regions setObject:region forKey:saveInfo.objId];
                [self addRegion:region];
			}
			
		}else if(IASaveTypeDelete == saveInfo.saveType){
			
            region = [self.allRegions objectForKey:saveInfo.objId];
			//删除
			//[(NSMutableDictionary*)self.regions removeObjectForKey:saveInfo.objId];
            [self removeRegion:region];
            			
		}
		
		
	}
	
    
    
    /*
    //告知，下次提醒
    IARegion *theRegion = [self.regions objectForKey:saveInfo.objId];;
    if (theRegion && lastLocation && [YCSystemStatus sharedSystemStatus].enabledLocation) {
        if (IAUserLocationTypeInner == region.userLocationType) {
            YCPromptView *promptView = [[[YCPromptView alloc] init] autorelease];
            promptView.promptViewStatus = YCPromptViewStatusWarn;
            promptView.dismissByTouch = YES;
            promptView.text = @"由于您现在离这个目的地很近，所以在下次进入目的地区域，才会提醒您！";
            [promptView performSelector:@selector(show) withObject:nil afterDelay:0.25];
            [promptView performSelector:@selector(dismissAnimated:) withObject:(id)kCFBooleanTrue afterDelay:8.0];
        }
    }
     */
    
    if (alarm.usedAlarmCalendar) {
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        [userInfo setObject:alarm.alarmId forKey:@"kLaunchIAlarmLocalNotificationKey"];
        
        NSString *iconString = nil;//这是钟表🕘
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
            iconString = @"\U0001F558";
        else 
            iconString = @"\ue02c";
        
        NSString *alarmName = alarm.alarmName ? alarm.alarmName : alarm.positionTitle;
        NSString *alertTitle =  [NSString stringWithFormat:@"%@%@",iconString,alarmName]; 
        NSString *alertMessage = @"单点这条消息，来启动位置闹钟！";
        NSString *notificationBody = [NSString stringWithFormat:@"%@: %@",alertTitle,alertMessage];
        
        UIApplication *app = [UIApplication sharedApplication];
        
        for (IAAlarmCalendar * anCalender in alarm.alarmCalendars) {
            UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
            notification.fireDate = anCalender.firstFireDate;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.repeatInterval = anCalender.repeatInterval;
            notification.soundName = alarm.sound.soundFileName;
            notification.alertBody = notificationBody;
            notification.userInfo = userInfo;
            [app scheduleLocalNotification:notification];
        }

    }
    
}

- (void)resetRegionsWithCurrentLocation:(CLLocation*)currentLocation{
	
    NSMutableDictionary* theRegions = (NSMutableDictionary*)self.regions;
	NSMutableDictionary* theAllRegions = (NSMutableDictionary*)self.allRegions;
	
	NSInteger oldCount = theRegions.count;
	[theRegions removeAllObjects];
	[theAllRegions removeAllObjects];
	for (IAAlarm *oneAlarm in [IAAlarm alarmArray]) {
		IARegion *region = [[IARegion alloc] initWithAlarm:oneAlarm currentLocation:currentLocation];
		
		if (oneAlarm.enabled) { //判断是否启用
			[theRegions setObject:region forKey:oneAlarm.alarmId];
		}
		
		[theAllRegions setObject:region forKey:oneAlarm.alarmId];
		[region release];//修改 2011-09-05
	}
    
    //生成数组
	[self genRegionArray];
    
	
	NSInteger newCount = theRegions.count;
	if (newCount != oldCount) { //有数量改变,发通知
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IARegionsDidChangeNotification 
																	  object:self 
																	userInfo:nil];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	}
    

}
/*
- (void) handle_applicationDidFinishLaunching:(id)notification {
	[self resetRegionsWithCurrentLocation:nil];
}
 */

- (void) registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmsDataListDidChange:)
							   name: IAAlarmsDataListDidChangeNotification
							 object: nil];
	/*
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidFinishLaunching:)
							   name: UIApplicationDidFinishLaunchingNotification
							 object: nil];
	 */
	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAAlarmsDataListDidChangeNotification object: nil];
	//[notificationCenter removeObserver:self	name: UIApplicationDidFinishLaunchingNotification object: nil];
}

/*
//坐标是否在任何一个预警范围中
- (BOOL)preAlarmRegionsContainCoordinate:(CLLocationCoordinate2D)coordinate{
	
	BOOL b = NO;
	NSArray *array = [self.regions allValues];
	for(IARegion *oneRegion in array){
		CLRegion *preAlarmRegion = 	oneRegion.preAlarmRegion;	
		if ([preAlarmRegion containsCoordinate:coordinate]) {
			b = YES;
			break;
		}
	}
	
	return b;
}

//坐标是否在任何一个大预警范围中
- (BOOL)bigPreAlarmRegionsContainCoordinate:(CLLocationCoordinate2D)coordinate{
	BOOL b = NO;
	NSArray *array = [self.regions allValues];
	for(IARegion *oneRegion in array){
		CLRegion *preAlarmRegion = 	oneRegion.bigPreAlarmRegion;	
		if ([preAlarmRegion containsCoordinate:coordinate]) {
			b = YES;
			break;
		}
	}
	
	return b;
}
 */


//包含这个坐标的区域。没有返回nil
- (NSArray*)containsRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate{
	
	NSMutableArray *reArray = nil;
	
	for (IARegion *theRegion in regionArray) {
		IAUserLocationType currentType = [theRegion containsCoordinate:coordinate];
		if (IAUserLocationTypeInner == currentType) {
			if (!reArray)
				reArray = [NSMutableArray array];
			[reArray addObject:theRegion];
		}
	}
	return reArray;
}

- (NSInteger)numberOfContainsRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate{
	NSInteger number = 0;
	
	for (IARegion *theRegion in regionArray) {
		IAUserLocationType currentType = [theRegion containsCoordinate:coordinate];
		if (IAUserLocationTypeInner == currentType) {
            number++;
		}
	}
	return number;
}

//包含这个坐标的的预警区域。没有返回nil
- (NSArray*)containsPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate{
	
    NSMutableArray *reArray = nil;
	
	for (IARegion *theRegion in regionArray) {
		CLRegion *preAlarmRegion = 	theRegion.preAlarmRegion;
		if ([preAlarmRegion containsCoordinate:coordinate]) {
			if (!reArray)
				reArray = [NSMutableArray array];
			[reArray addObject:theRegion];
		}
	}
	return reArray;
}

- (NSInteger)numberOfContainsPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate{
    NSInteger number = 0;
	
	for (IARegion *theRegion in regionArray) {
		CLRegion *preAlarmRegion = 	theRegion.preAlarmRegion;
		if ([preAlarmRegion containsCoordinate:coordinate]) {
            number++;
		}
	}
	return number;
}

//包含这个坐标的大预警区域。没有返回nil
- (NSArray*)containsBigPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate{
	NSMutableArray *reArray = nil;
	
	for (IARegion *theRegion in regionArray) {
		CLRegion *preAlarmRegion = 	theRegion.bigPreAlarmRegion;
		if ([preAlarmRegion containsCoordinate:coordinate]) {
			if (!reArray)
				reArray = [NSMutableArray array];
			[reArray addObject:theRegion];
		}
	}
	return reArray;
}

- (NSInteger)numberOfContainsBigPreAlarmRegionsWithCoordinate:(CLLocationCoordinate2D)coordinate{
    NSInteger number = 0;
	
	for (IARegion *theRegion in regionArray) {
		CLRegion *preAlarmRegion = 	theRegion.bigPreAlarmRegion;
		if ([preAlarmRegion containsCoordinate:coordinate]) {
            number++;
		}
	}
	return number;
}


//坐标是否能引起列表中的区域类型发生改变
- (BOOL)canChangeUserLocationTypeForCoordinate:(CLLocationCoordinate2D)coordinate{

	BOOL b = NO;
	for (IARegion *region in regionArray) {
		IAUserLocationType currentType = [region containsCoordinate:coordinate];

		//CLLocation *location = [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] autorelease];
		//CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:region.region.center.latitude longitude:region.region.center.longitude] autorelease];
		//CLLocationDistance d = [location distanceFromLocation:aLocation];
		//NSString *s0 = [NSString stringWithFormat:@"检测－－ %@ Type = %d 距离当前位置 = %.1fm",region.alarm.alarmName ,currentType,d];
		//[[YCLog logSingleInstance] addlog:s0];
        
		if (currentType != region.userLocationType && currentType != IAUserLocationTypeEdge ) {
			b = YES;
			break;
		}
	}
	
	return b;
	
}

//是否能检测出所有区域与theLocation的距离（与theLocation的精度有关）
- (BOOL)canDetermineDistanceFromLocation:(const CLLocation *)theLocation{
	
	BOOL b = YES;
	for (IARegion *region in allRegionArray) {
		CLLocationDistance d = [region distanceFromLocation:theLocation];
		
		if (theLocation.horizontalAccuracy > kMiddleAccuracyThreshold) { //精度低于xx
			if (d < kDistanceRadiusRateWhenLowAccuracyThreshold * region.region.radius){ //距离小于x倍的半径
				b = NO;
				break;
			}
				
		}
		

	}
	
	return b;
}


- (id)init{
    self=[super init];
	if (self) {
		//[self resetRegionsWithCurrentLocation:nil];
        [self resetRegionsWithCurrentLocation:[YCSystemStatus sharedSystemStatus].lastLocation];
		[self registerNotifications];
	}
	return self;
}
 

- (BOOL)isDetectingWithAlarm:(IAAlarm*)alarm{
    for (IARegion* oneObj in [self.regions allValues]) {
        if ([oneObj.alarm.alarmId isEqualToString:alarm.alarmId]) {
            return [oneObj isDetecting];
        }
    }
    return NO; //上面的循环中没找到这个alarm
}

 
/*
- (void)awakeFromNib{
	[self registerNotifications];
}
 */




+ (IARegionsCenter*)sharedRegionCenter
{
	static IARegionsCenter *regionCenter =nil;
	if (regionCenter == nil) {
		regionCenter = [[IARegionsCenter alloc] init];
		
	}
	return regionCenter;
}

- (void)dealloc {
	[self unRegisterNotifications];
	[regions release];
    [regionArray release];
	[allRegions release];
    [allRegionArray release];
    [super dealloc];
}


@end
