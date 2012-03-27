//
//  iAlarmAppDelegate.m
//  iAlarm
//
//  Created by li shiyong on 10-11-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LocationManagerFactory.h"
#import "IABasicLocationManager.h"
#import "IARegionMonitoringLocationManager.h"
#import "NSObject-YC.h"
#import "ShareAppConfig.h"
#import "LocalizedStringAbout.h"
#import "IANotifications.h"
#import "BackgroundViewController.h"
#import "YCPositionType.h"
#import "YClocationServicesUsableAlert.h"
#import "YCSystemStatus.h"
#import "UIApplication-YC.h"
#import "IARegionsCenter.h"
#import "YCSoundPlayer.h"
#import "YCParam.h"
#import "IARegion.h"
#import "YCRepeatType.h"
#import "YCSound.h"
#import "AlarmsMapListViewController.h"
#import "IAAlarm.h"
#import "IALocationManager.h"
#import "YCLog.h"
#import "UIUtility.h"
#import "iAlarmAppDelegate.h"


@implementation iAlarmAppDelegate


@synthesize window;
//@synthesize viewController;
@synthesize navigationController;

@synthesize lastRegion;
@synthesize lastCurrentLocation;

@synthesize soundPlayer;
@synthesize ringplayer;

- (id)locationServicesUsableAlert{
	if (!locationServicesUsableAlert) {
		locationServicesUsableAlert = [[YClocationServicesUsableAlert alloc] init];
	}
	
	return locationServicesUsableAlert;
}


- (void)applicationSignificantTimeChange:(UIApplication *)application{
}


- (YCSoundPlayer*)vibratePlayer{
	if (vibratePlayer == nil) {
		vibratePlayer = [[YCSoundPlayer alloc] initWithVibrate];
	}
	return vibratePlayer;
}

 
/*
- (id<IALocationManagerInterface>)locationManager{
	if (locationManager == nil) {
        if ([YCParam paramSingleInstance].regionMonitoring) 
            locationManager = [[IARegionMonitoringLocationManager alloc] init]; //使用区域监控的定位
        else
            //locationManager = [[IALocationManager alloc] init];
            locationManager = [[IABasicLocationManager alloc] init];

        
		locationManager.delegate =self;
	}
	return locationManager;
}
 */

- (id)confirmRateAlertView{
	if (confirmRateAlertView == nil) {
		
		confirmRateAlertView = [[UIAlertView alloc] initWithTitle:kAlertConfirmRateTitle 										
														  message:kAlertConfirmRateBody 
														 delegate:self 
												cancelButtonTitle:kAlertConfirmRateBtnNoThanks  
												otherButtonTitles:kAlertConfirmRateBtnToRate,kAlertConfirmRateBtnNotToremind,nil];
		 
	}
	return confirmRateAlertView;
}

#pragma mark -
#pragma mark notification

/*
//为了延时调用
- (void)selectedFirstIndex{
	self.tabBarController.selectedIndex = 0;
}

- (void)handle_regionArrived:(id)notification{

	//弹出没有保存的alarm详细视图
	UIViewController *nav1Controller = [self.tabBarController selectedViewController];
	UIViewController *rootViewContoller = [((UINavigationController*)nav1Controller).viewControllers objectAtIndex:0];
	[rootViewContoller dismissModalViewControllerAnimated:YES];
	 
	//找到地图控制器
	UINavigationController *mapNavController = [self.tabBarController.viewControllers objectAtIndex:0];
	AlarmsMapListViewController *rootMapViewContoller = [((UINavigationController*)mapNavController).viewControllers objectAtIndex:0];
	if ([rootMapViewContoller isKindOfClass:[AlarmsMapListViewController class]]) 
	{
		
		//rootMapViewContoller.alarms = [IAAlarm alarmArray]; //如果使第一次打开
		//在tab上选中
		//self.tabBarController.selectedIndex = 0;
		[self performSelector:@selector(selectedFirstIndex) withObject:nil afterDelay:0.0];
		
		NSTimeInterval delay = 1.2;
		if ([rootMapViewContoller isViewLoaded]) {
			delay = 0.0;
		}
		[rootMapViewContoller performSelector:@selector(findAlarm:) withObject:self.lastRegion.alarm afterDelay:delay]; //为第一次打开，延后
	}
	
}
 */


- (void)registerNotifications {
	//[self addObserver:self forKeyPath:@"soundPlayer.playing" options:NSKeyValueObservingOptionNew context:nil];
	
	//NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	/*
	[notificationCenter addObserver: self
						   selector: @selector (handle_regionArrived:)
							   name: IAAlarmsRegionArrivedNotification
							 object: nil];
	 */
    
	 

}


- (void)unRegisterNotifications{
	//[self removeObserver:self forKeyPath:@"soundPlayer.playing"];
	
	//NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	//[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
}

#pragma mark -
#pragma mark Application lifecycle
/*
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	//角标
    application.applicationIconBadgeNumber = 0;
	
	//清空
	YCSystemStatus *status = [YCSystemStatus deviceStatusSingleInstance];
	NSMutableArray *alarmIds = status.localNotificationIdentifiers;
	[alarmIds removeAllObjects];
	
	//点了通知的查看按钮
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmDidViewNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
}
 */


//const NSInteger kMapViewControllerIndex = 0;

- (void)testLocationServices{
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	if ([YCSystemStatus deviceStatusSingleInstance].applicationDidFinishLaunchNumber > 1) {
		[self.locationServicesUsableAlert locationServicesUsable];
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
	//[[[NSBundle mainBundle] infoDictionary] setValue:@"Default-list.png" forKey:@"UILaunchImageFile"];

	
    //处理没有被查看的到达区域
    ////角标
    //application.applicationIconBadgeNumber = 0; //放在判断的外边，免得总有角标 
	[application performSelector:@selector(setApplicationIconBadgeNumber:) withInteger:0 afterDelay:0.1];//延时为了给弹评分对话框提供依据

	
	//清空
	YCSystemStatus *status = [YCSystemStatus deviceStatusSingleInstance]; //一定要有这个初始化
	NSMutableArray *alarmIds = status.localNotificationIdentifiers;
	[alarmIds removeAllObjects];

	
    //self.window.rootViewController = self.viewController;
	self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];	
	
    [[IARegionsCenter regionCenterSingleInstance] regions];  //一定要有这个初始化
    
    self->locationManager = [LocationManagerFactory locationManagerInstanceWithDelegate:self];
    [self->locationManager start];
    
    

	[self registerNotifications];
	
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	//[self.locationServicesUsableAlert performSelector:@selector(locationServicesUsable) withObject:nil afterDelay:2.0];
	[self performSelector:@selector(testLocationServices) withObject:nil afterDelay:3.0];
	
	
	
	//不停止其他程序的音乐播放
	NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
    //[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setActive:YES error:&error];

	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

	//失去了活动就别唱了
	//[self.soundPlayer stop];
	[self.ringplayer stop];
	[self.vibratePlayer stop];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	//NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImageFile"];
	//[[[NSBundle mainBundle] infoDictionary] setValue:@"Default-list.png" forKey:@"UILaunchImageFile"];
	
}
 


- (void)applicationWillEnterForeground:(UIApplication *)application {
	
    if (application.applicationIconBadgeNumber > 0) {
        
        //application.applicationIconBadgeNumber = 0;
		[application performSelector:@selector(setApplicationIconBadgeNumber:) withInteger:0 afterDelay:0.1];//延时为了给弹评分对话框提供依据
		
		//清空
		YCSystemStatus *status = [YCSystemStatus deviceStatusSingleInstance];
		NSMutableArray *alarmIds = status.localNotificationIdentifiers;
		[alarmIds removeAllObjects];
        
        //打开地图，查看最后一个到达的区域
		NSDictionary *userInfoDic = [NSDictionary dictionaryWithObject:self.lastRegion.alarm forKey:IAViewedAlarmKey];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmDidViewNotification object:self userInfo:userInfoDic];
        [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
        
    } 
	
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	[self.locationServicesUsableAlert performSelector:@selector(locationServicesUsable) withObject:nil afterDelay:1.0];

	
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	
		
	BOOL alreadyRate = [YCSystemStatus deviceStatusSingleInstance].alreadyRate;
	BOOL notToRemindRate = [YCSystemStatus deviceStatusSingleInstance].notToRemindRate;
	
	//没有评过 且 没点过不再提示 且 (闹钟提示过一次 或 每启动x次)
	BOOL letAlertShow = (!alreadyRate) && (!notToRemindRate) && ( application.applicationIconBadgeNumber > 0 );//没有评过 且 没点过不再提示 且 提醒过
	
    NSInteger applicationDidBecomeActiveNumber = [YCSystemStatus deviceStatusSingleInstance].applicationDidBecomeActiveNumber;
    letAlertShow = letAlertShow || (applicationDidBecomeActiveNumber == kLetOneVisibleBecomeActiveNumber); //或 启动次数大于规定次数
    
	//弹出要求评分的对话框
	if (letAlertShow) {
		[self.confirmRateAlertView performSelector:@selector(show) withObject:nil afterDelay:4.0];
	}
}


- (void)applicationWillTerminate:(UIApplication *)application{
    //NSLog(@"位置闹钟 applicationWillTerminate");
    //[[YCLog logSingleInstance] addlog:@"位置闹钟 applicationWillTerminate"];
}




#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[soundPlayer release];
	soundPlayer = nil;
	[vibratePlayer release];
	vibratePlayer = nil;
	[ringplayer release];
	ringplayer = nil;
	
	[lastRegion release];
	lastRegion = nil;
	[lastCurrentLocation release];
	lastCurrentLocation = nil;
	[locationServicesUsableAlert release];
	locationServicesUsableAlert = nil;
	
	[confirmRateAlertView release];
	confirmRateAlertView = nil;
}


- (void)dealloc {
    //[viewController release];
	[navigationController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

 

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

	//要求评分的提示框
	if (alertView == self.confirmRateAlertView) {
		//NSLog(@"index = %d",buttonIndex);
		if (buttonIndex == 0) {//cancel
			//
		}else if (buttonIndex == 1){ // to Rate
			[YCSystemStatus deviceStatusSingleInstance].alreadyRate = YES;
			NSString *str = [NSString stringWithFormat: 
							 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppStoreAppID]; 
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
			
		}else if (buttonIndex == 2){//Not to remind 
			[YCSystemStatus deviceStatusSingleInstance].notToRemindRate = YES;
		}

		return;
	}
	
	[self.ringplayer stop];
	[self.vibratePlayer stop];
	if (buttonIndex == 1) { //查看按钮
		NSDictionary *userInfoDic = [NSDictionary dictionaryWithObject:self.lastRegion.alarm forKey:IAViewedAlarmKey];
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmDidViewNotification object:self userInfo:userInfoDic];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
	}else{
        [self.lastRegion.alarm saveFromSender:self]; //不查看。为了有可能变灰，重新保存发通知
        
        //清空
        YCSystemStatus *status = [YCSystemStatus deviceStatusSingleInstance];
        NSMutableArray *alarmIds = status.localNotificationIdentifiers;
        [alarmIds removeAllObjects];
    }
}

#pragma mark -
#pragma mark IALocationManagerDelegate

- (void)alertRegion:(IARegion*)region arrived:(BOOL)arrived atCurrentLocation:(CLLocation*)currentLocation{
	
	//通知有离开或到达
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmDidAlertNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
	
	self.lastRegion = region;
	self.lastCurrentLocation = currentLocation;
	
	IAAlarm *alarm = region.alarm;
	
	
	NSString *alertBody = nil;
	
	CLLocationCoordinate2D curCoordinate = currentLocation.coordinate;
	if (CLLocationCoordinate2DIsValid(curCoordinate)) {
		
		CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:curCoordinate.latitude longitude:curCoordinate.longitude];
		CLLocation *regLocation = [[CLLocation alloc] initWithLatitude:alarm.coordinate.latitude longitude:alarm.coordinate.longitude];
		CLLocationDistance distance = [curLocation distanceFromLocation:regLocation];	
		NSString *promptTemple = arrived?kAlertFrmStringArrived:kAlertFrmStringLeaved;
		alertBody = [[[NSString alloc] initWithFormat:promptTemple,alarm.alarmName,distance] autorelease];
		
		//修改 2011-09-05
		[curLocation release];
		[regLocation release];
		
	}

	
	UIApplication *app = [UIApplication sharedApplication];
	if (UIApplicationStateActive == app.applicationState) { //活动状态
		
		[UIUtility simpleAlertBody:alertBody alertTitle:alarm.alarmName cancelButtonTitle:kAlertBtnClose OKButtonTitle:kAlertBtnView delegate:self];
		
		///////////////////////////////////
		//声音、振动
		if (self.ringplayer ==nil || !self.ringplayer.playing){
			if (alarm.sound.soundFileURL){
				self.ringplayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:alarm.sound.soundFileURL error:NULL] autorelease];
				self.ringplayer.delegate = self;
				self.ringplayer.numberOfLoops = 100;
				[self.ringplayer play];
			}
		}
		
		if (alarm.vibrate) {
			if (!self.vibratePlayer.playing)
				[self.vibratePlayer playRepeatNumber:-1];
		}
		///////////////////////////////////
		
		
	}else {
        
        YCSystemStatus *systmStaus = [YCSystemStatus deviceStatusSingleInstance];
        NSInteger applicationIconBadgeNumber = [systmStaus.localNotificationIdentifiers count]; //角标数
        [UIUtility sendNotifyWithAlertBody:alertBody soundName:alarm.sound.soundFileName applicationIconBadgeNumber:applicationIconBadgeNumber];
		
	}
}

- (void)locationManager:(IALocationManager *)manager didEnterRegion:(IARegion *)region
{
	IAAlarm *alarm = region.alarm;
	if ([alarm.positionType.positionTypeId isEqualToString:@"p001"]) { //是 “离开时候”提醒
		return; 
	}


    //加入到列表中
    YCSystemStatus *systmStaus = [YCSystemStatus deviceStatusSingleInstance];
    [systmStaus.localNotificationIdentifiers addObject:region.alarm.alarmId];
    
	[self alertRegion:region arrived:YES atCurrentLocation:manager.standardLocationManager.location];
	
	//只闹一次
	if ([alarm.repeatType.repeatTypeId isEqualToString:@"r001"]) 
	{
		alarm.enabling = NO;
		[alarm saveFromSender:self];
	}
	
}

- (void)locationManager:(IALocationManager *)manager didExitRegion:(IARegion *)region
{	
	//关闭离开通知
	//if([YCParam paramSingleInstance].closeLeaveNotify) return;

	IAAlarm *alarm = region.alarm;
	if ([alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //是 “到达时候”提醒
		return; 
	}
	
	
    //加入到列表中
    YCSystemStatus *systmStaus = [YCSystemStatus deviceStatusSingleInstance];
    [systmStaus.localNotificationIdentifiers addObject:region.alarm.alarmId];
    
	[self alertRegion:region arrived:NO atCurrentLocation:manager.standardLocationManager.location];
	
	//只闹一次
	if ([alarm.repeatType.repeatTypeId isEqualToString:@"r001"]) 
	{
		alarm.enabling = NO;
		[alarm saveFromSender:self];
	}

}

#pragma mark -
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	[self.vibratePlayer stop];
}



@end

