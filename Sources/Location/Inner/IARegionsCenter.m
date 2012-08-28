//
//  RegionCenter.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCPositionType.h"
#import "IAAlarmSchedule.h"
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

@synthesize regions = _regions;

- (void)addRegions:(NSArray*)regions{
    if (regions.count > 0) {
        
        for (IARegion *aRegion in regions) {
            [_regions setObject:aRegion forKey:aRegion.alarm.alarmId];
        }
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotification = [NSNotification notificationWithName:IARegionsDidChangeNotification 
                                                                      object:self 
                                                                    userInfo:nil];
        [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    }
}

- (void)addRegion:(IARegion*)region{
    [self addRegions:[NSArray arrayWithObject:region]];
}

- (void)removeRegions:(NSArray*)regions{
    if (regions.count > 0) {
        
        for (IARegion *aRegion in regions) {
            [_regions removeObjectForKey:aRegion.alarm.alarmId];
        }
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotification = [NSNotification notificationWithName:IARegionsDidChangeNotification 
                                                                      object:self 
                                                                    userInfo:nil];
        [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    }
}

- (void)removeRegion:(IARegion*)region{
    [self removeRegions:[NSArray arrayWithObject:region]];
}

#pragma mark - timer

- (void)timerFired:(NSTimer *)timer
{
    /*
    //取消timer启动闹钟的通知－不需要这个通知来启动了
    UILocalNotification *aNotification = [timer.userInfo objectForKey:@"kAlarmScheduleNotificationKey"];
    if (aNotification) 
        [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
     */
    
    //把应该启动都启动了。延时1秒为了在 [UIApplicationDelegate applicationDidBecomeActive:]后执行
    [self performSelector:@selector(checkAlarmsForAddWithCurrentLocation:) withObject:nil afterDelay:1.0];
}

#pragma mark - Notification

//闹钟列表发生变化
- (void)handleAlarmsDataListDidChange:(id)notification {
	
    CLLocation *lastLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
    
    IARegion *region = nil;
    IAAlarm *alarm = nil;
	IASaveInfo *saveInfo = [((NSNotification*)notification).userInfo objectForKey:IASaveInfoKey];
	if (saveInfo) {
		NSString *alarmId = saveInfo.objId;
        
		if (IASaveTypeUpdate == saveInfo.saveType) {
			
            alarm = [IAAlarm findForAlarmId:alarmId];
            region = [[[IARegion alloc] initWithAlarm:alarm currentLocation:lastLocation] autorelease];
            
            //先删除
			[self removeRegion:region];
            //再增加
            if (alarm.shouldWorking) {//判断是否启用
                [self addRegion:region];
			}
			
		}else if(IASaveTypeAdd == saveInfo.saveType){
			
			//增加
			alarm = [IAAlarm findForAlarmId:alarmId];
            region = [[[IARegion alloc] initWithAlarm:alarm currentLocation:lastLocation] autorelease];
			if (alarm.shouldWorking) {//判断是否启用
                [self addRegion:region];
			}
			
		}else if(IASaveTypeDelete == saveInfo.saveType){
			
            region = [self.regions objectForKey:alarmId];
			//删除
            if (region)
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
            promptView.text = KTextWaringNexttimeAlarm;
            [promptView performSelector:@selector(show) withObject:nil afterDelay:0.25];
            [promptView performSelector:@selector(dismissAnimated:) withObject:(id)kCFBooleanTrue afterDelay:8.0];
        }
    }
     */
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handleAlarmsDataListDidChange:)
							   name: IAAlarmsDataListDidChangeNotification     //闹钟列表发生变化
                             object: nil]; 
	
}

//坐标是否能引起列表中的区域类型发生改变
- (BOOL)canChangeUserLocationTypeForCoordinate:(CLLocationCoordinate2D)coordinate{
    BOOL b = NO;
    
    NSEnumerator *enumerator = [_regions objectEnumerator];
    IARegion *aRegion = nil;    
    while ((aRegion = [enumerator nextObject])) {
        IAUserLocationType currentType = [aRegion containsCoordinate:coordinate];
		if (currentType != aRegion.userLocationType && currentType != IAUserLocationTypeEdge ) {
			b = YES;
			break;
		}
    }
    
	return b;
}

- (void)checkRegionsForRemove{
    
    NSMutableArray *temps = nil;
    NSEnumerator *enumerator = [_regions objectEnumerator];
    IARegion *aRegion = nil;    
    while ((aRegion = [enumerator nextObject])) {
		if (!aRegion.alarm.shouldWorking) {
            if (temps == nil) 
                temps = [NSMutableArray array];
			[temps addObject:aRegion];
		}
    }
    
    if (temps.count > 0) 
        [self removeRegions:temps];
    
}

- (NSArray*)checkAlarmsForAddWithCurrentLocation:(CLLocation*)currentLocation{
    //NSLog(@"checkAlarmsForAddWithCurrentLocation = %@",currentLocation);
    NSArray *alarms = [IAAlarm alarmArray];
    NSMutableArray *temps = nil;
    
    for (IAAlarm *anAlarm in alarms) {
        
        if ([_regions objectForKey:anAlarm.alarmId] == nil && anAlarm.shouldWorking) {
            
            //NSLog(@"anAlarm.shouldWorking");
            
            //先取消通知，再发。为了取消本次提醒
            [anAlarm.alarmSchedules makeObjectsPerformSelector:@selector(cancelLocalNotification)];
            if (anAlarm.usedAlarmSchedule) {
                for (IAAlarmSchedule * aCalender in anAlarm.alarmSchedules) {
                    
                    if (aCalender.vaild) {
                        NSString *alertTitle = anAlarm.alarmName ? anAlarm.alarmName : anAlarm.positionTitle;
                        [aCalender scheduleLocalNotificationWithAlarmId:anAlarm.alarmId title:alertTitle message:nil soundName:anAlarm.sound.soundFileName];
                    }
                    
                }
            }
            
            IARegion *region = nil;
            if (currentLocation) {
                region = [[[IARegion alloc] initWithAlarm:anAlarm currentLocation:currentLocation] autorelease];
            }else {
                IAUserLocationType type = [anAlarm.positionType.positionTypeId isEqualToString:@"p002"] ? IAUserLocationTypeOuter : IAUserLocationTypeInner; //p002 到达提醒。把区域类型设置成马上触发的情况
                region = [[[IARegion alloc] initWithAlarm:anAlarm userLocationType:type] autorelease];
            }
            
            
            if (temps == nil)
                temps = [NSMutableArray array];
            [temps addObject:region];
        }
        
    }

    if (temps.count > 0) 
        [self addRegions:temps];
    
    return temps;
}

#pragma mark - Init

- (id)init{
    //NSLog(@"IARegionsCenter init");
    self = [super init];
    if (self) {
        
        //初始化列表
        _regions = [[NSMutableDictionary dictionary] retain];
        //
		[self registerNotifications];
	}
    return self;
}

#pragma mark - single Instance

static IARegionsCenter *single =nil;
+ (IARegionsCenter*)sharedRegionCenter{
    if (single == nil) {
        single = [[super allocWithZone:NULL] init];
    }
    return single;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedRegionCenter] retain];
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
