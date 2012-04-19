//
//  iAlarmAppDelegate.m
//  iAlarm
//
//  Created by li shiyong on 10-11-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NSString-YC.h"
#import "IAAlarmFindViewController.h"
#import "IAAlarmNotification.h"
#import "IAAlarmNotificationCenter.h"
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
@synthesize navigationController;

@synthesize soundPlayer;
@synthesize ringplayer;

- (id)locationServicesUsableAlert{
	if (!locationServicesUsableAlert) {
		locationServicesUsableAlert = [[YClocationServicesUsableAlert alloc] init];
	}
	
	return locationServicesUsableAlert;
}

- (YCSoundPlayer*)vibratePlayer{
	if (vibratePlayer == nil) {
		vibratePlayer = [[YCSoundPlayer alloc] initWithVibrate];
	}
	return vibratePlayer;
}

#pragma mark - Utility

-(void)viewNotificationedAlarm:(BOOL)animated{
    //弹出显示曾经的通知
    NSArray *notifications =[[IAAlarmNotificationCenter defaultCenter] notificationsForFired:YES];
    if (notifications.count > 0) {
        IAAlarmFindViewController *ctler = [[[IAAlarmFindViewController alloc] initWithNibName:@"IAAlarmFindViewController" bundle:nil alarmNotifitions:notifications indexForView:indexForView] autorelease];
        UINavigationController *navCtler = [[[UINavigationController alloc] initWithRootViewController:ctler] autorelease];
        
        UIViewController *currentController = self.navigationController.modalViewController;
        currentController = currentController ? currentController : self.navigationController; 
        [currentController presentModalViewController:navCtler animated:animated]; //程序在启动中:NO。从后台进入:YES
        
        [[IAAlarmNotificationCenter defaultCenter] removeFiredNotification];
    }
    
    
}

- (void)setAlarmNotificationWithLocalNotification:(UILocalNotification *)notification{
    
     indexForView = 0;
     [alarmNotification_ release];
     alarmNotification_ = nil;

    NSString *notificationId = [[notification.userInfo allValues] objectAtIndex:0];
    if (notificationId) {
        NSArray *array = [[IAAlarmNotificationCenter defaultCenter] notificationsForFired:YES];
        for (IAAlarmNotification *anObj in array) {
            if ([anObj.notificationId isEqualToString:notificationId]) {
                indexForView = [array indexOfObject:anObj];
                alarmNotification_ = [anObj retain];
                break;
            }
        }
    }
     
}

#pragma mark -
#pragma mark Application lifecycle

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    UIApplicationState state = application.applicationState;
    [application performSelector:@selector(setApplicationIconBadgeNumber:) withInteger:0 afterDelay:0.1];//为评分判断留时间
    
    [self setAlarmNotificationWithLocalNotification:notification];
    if (UIApplicationStateActive == state) {//第五种情况：程序在激活状态下收到本地通知

        //框
        if (!viewAlarmAlertView) {
            viewAlarmAlertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:kAlertBtnClose otherButtonTitles:kAlertBtnView, nil];
        }
        viewAlarmAlertView.message = notification.alertBody;
        [viewAlarmAlertView show];
        
        ///////////////////////////////////
        //声音、振动
        if (self.ringplayer ==nil || !self.ringplayer.playing){
            if (alarmNotification_.alarm.sound.soundFileURL){
                self.ringplayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:alarmNotification_.alarm.sound.soundFileURL error:NULL] autorelease];
                self.ringplayer.delegate = self;
                self.ringplayer.numberOfLoops = 100;
                //[self.ringplayer play];
                [self.ringplayer performSelector:@selector(play) withObject:nil afterDelay:0.0];
            }
        }
        
        if (alarmNotification_.alarm.vibrate) {
            if (!self.vibratePlayer.playing)
                [self.vibratePlayer performSelector:@selector(playRepeatNumber:) withInteger:2 afterDelay:0.0];
                //[self.vibratePlayer playRepeatNumber:-1];
            
        }
        ///////////////////////////////////
    }else{//第三种情况：程序因响应本地通知而激活
        animatedView = YES;
    }
    
    
}
 


//const NSInteger kMapViewControllerIndex = 0;

- (void)testLocationServices{
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	if ([YCSystemStatus deviceStatusSingleInstance].applicationDidFinishLaunchNumber > 1) {
		[self.locationServicesUsableAlert locationServicesUsable];
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
	[YCSystemStatus deviceStatusSingleInstance]; //一定要有这个初始化

	
    //self.window.rootViewController = self.viewController;
	self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];	
	
    [[IARegionsCenter regionCenterSingleInstance] regions];  //一定要有这个初始化
    
    self->locationManager = [LocationManagerFactory locationManagerInstanceWithDelegate:self];
    [self->locationManager start];
    
    
	//[self registerNotifications];
	
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	//[self.locationServicesUsableAlert performSelector:@selector(locationServicesUsable) withObject:nil afterDelay:2.0];
	[self performSelector:@selector(testLocationServices) withObject:nil afterDelay:3.0];
	
	
	
	//不停止其他程序的音乐播放
	NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
    //[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    
    //因为响应本地通知到达而启动的
    id theLocalNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (theLocalNotification) { //第一种情况：程序因响应本地通知的到达而启动
        [self setAlarmNotificationWithLocalNotification:theLocalNotification];
    }else{//第二种情况：程序直接启动
        indexForView = 0;
    }
    animatedView = NO;
    
    
    [application performSelector:@selector(setApplicationIconBadgeNumber:) withInteger:0 afterDelay:0.1];//为评分判断留时间
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

	//失去了活动就别唱了
	[self.ringplayer stop];
	[self.vibratePlayer stop];
    
    application.applicationIconBadgeNumber = 0;
    [[IAAlarmNotificationCenter defaultCenter] removeFiredNotification];
    [viewAlarmAlertView dismissWithClickedButtonIndex:0 animated:NO];
    [confirmRateAlertView dismissWithClickedButtonIndex:0 animated:NO];
    
    //第四种情况：程序直接进入。在这里设置需要的参数
    indexForView = 0;
    animatedView = YES;
 
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
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
        if (!confirmRateAlertView) {
            confirmRateAlertView = [[UIAlertView alloc] initWithTitle:kAlertConfirmRateTitle 										
                                                              message:kAlertConfirmRateBody 
                                                             delegate:self 
                                                    cancelButtonTitle:kAlertConfirmRateBtnNoThanks  
                                                    otherButtonTitles:kAlertConfirmRateBtnToRate,kAlertConfirmRateBtnNotToremind,nil];
        }
		[confirmRateAlertView performSelector:@selector(show) withObject:nil afterDelay:4.0];
	}
    
    //
    [self viewNotificationedAlarm:animatedView];
        
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

	[locationServicesUsableAlert release];
	locationServicesUsableAlert = nil;
	
	[confirmRateAlertView release];
	confirmRateAlertView = nil;
    [viewAlarmAlertView release]; viewAlarmAlertView = nil;
    
}

- (void)dealloc {
    //[viewController release];
	[navigationController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView == viewAlarmAlertView) {
        [self.ringplayer stop];
        [self.vibratePlayer stop];
        
        if (buttonIndex == 1) { //查看按钮
            [self viewNotificationedAlarm:YES];
        }
        [[IAAlarmNotificationCenter defaultCenter] removeFiredNotification];
        
    }else if (alertView == confirmRateAlertView) {
        //要求评分的提示框
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
        
    }
}

#pragma mark -
#pragma mark IALocationManagerDelegate

- (void)alertRegion:(IARegion*)region arrived:(BOOL)arrived atCurrentLocation:(CLLocation*)currentLocation{
	
	//通知有离开或到达
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmDidAlertNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];

	
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

    
    //保存到文件
    IAAlarmNotification *anAlarmNotification = [[[IAAlarmNotification alloc] initWithAlarm:alarm] autorelease];
    [[IAAlarmNotificationCenter defaultCenter] addNotification:anAlarmNotification];
    
    //发本地通知
    UIApplication *app = [UIApplication sharedApplication];
    NSInteger badgeNumber = app.applicationIconBadgeNumber + 1; //角标数
    NSString *alarmNotes = [alarm.notes trim];
    if (alarmNotes && alarmNotes.length > 0) {
        alertBody = [NSString stringWithFormat:@"%@: %@",alertBody,alarmNotes];
    }
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    notification.soundName = alarm.sound.soundFileName;
    notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber = badgeNumber;
    notification.userInfo = [NSDictionary dictionaryWithObject:anAlarmNotification.notificationId forKey:@"knotificationId"];
    [app scheduleLocalNotification:notification];

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

