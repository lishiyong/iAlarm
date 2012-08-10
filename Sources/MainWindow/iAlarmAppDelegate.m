//
//  iAlarmAppDelegate.m
//  iAlarm
//
//  Created by li shiyong on 10-11-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "IARegionsCenter+Debug.h"
#import "YCLib.h"
#import "IAAlarmFindViewController.h"
#import "IAAlarmNotification.h"
#import "IAAlarmNotificationCenter.h"
#import "IALocationAlarmManager.h"
#import "ShareAppConfig.h"
#import "LocalizedStringAbout.h"
#import "IANotifications.h"
#import "BackgroundViewController.h"
#import "YCPositionType.h"
#import "YCSystemStatus.h"
#import "IARegionsCenter.h"
#import "YCParam.h"
#import "IARegion.h"
#import "YCRepeatType.h"
#import "YCSound.h"
#import "AlarmsMapListViewController.h"
#import "IAAlarm.h"
#import "YCLog.h"
#import "UIUtility.h"
#import "iAlarmAppDelegate.h"


@implementation iAlarmAppDelegate


@synthesize window;
@synthesize viewController;

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
        
        UIViewController *currentController = self.viewController.modalViewController;
        currentController = currentController ? currentController : self.viewController; 
        [currentController presentModalViewController:navCtler animated:animated]; //程序在启动中:NO。从后台进入:YES
        
        [[IAAlarmNotificationCenter defaultCenter] removeFiredNotification];
    }
    
    
}

- (void)setAlarmNotificationWithLocalNotification:(UILocalNotification *)notification{
    
     indexForView = 0;
     [alarmNotification_ release];
     alarmNotification_ = nil;

    NSString *notificationId = [notification.userInfo objectForKey:@"knotificationId"];
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

- (void)checkAlarmsForAdd{
    NSArray *array = [[IARegionsCenter sharedRegionCenter] checkAlarmsForAddWithCurrentLocation:nil];
    if (array.count > 0) {
        
        //界面提示
        //UIApplicationState state = [UIApplication sharedApplication].applicationState;
        //if (UIApplicationStateActive == state)
        {
            YCPromptView *promptView = [[[YCPromptView alloc] init] autorelease];
            promptView.promptViewStatus = YCPromptViewStatusOK;
            promptView.text = KTextAlarmHasLaunched;
            promptView.dismissByTouch = YES;
            [promptView performSelector:@selector(show) withObject:nil afterDelay:0.25];
            [promptView performSelector:@selector(dismissAnimated:) withObject:(id)kCFBooleanTrue afterDelay:5.0];
        }
        
    }
}

- (BOOL)didReceiveLaunchIAlarmLocalNotification:(UILocalNotification *)notification{
    //启动闹钟通知
    NSString *alarmId = [notification.userInfo objectForKey:@"kLaunchIAlarmLocalNotificationKey"];
    if (alarmId) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark Application lifecycle

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification ");
    
    //测试按钮会禁用
    if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    //取消通知，不然通知可能反复出现
    [self performBlock:^{
        for (UILocalNotification *aLn in application.scheduledLocalNotifications) {
            NSString *notificationId = [aLn.userInfo objectForKey:@"knotificationId"];
            if (notificationId) {
                [application cancelLocalNotification:aLn];
            }
        }
    } afterDelay:1.0];
    
    if ([self didReceiveLaunchIAlarmLocalNotification:notification]) { //是定时启动通知
        return;
    }
    
    UIApplicationState state = application.applicationState;
    [self setAlarmNotificationWithLocalNotification:notification];
    if (UIApplicationStateActive == state) {//第五种情况：程序在激活状态下收到本地通知

        //框
        if (!viewAlarmAlertView) {
            viewAlarmAlertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:kAlertBtnClose otherButtonTitles:kAlertBtnView, nil];
        }
        NSString *iconString = [notification.userInfo objectForKey:@"kIconStringKey"];
        NSString *titleString = [notification.userInfo objectForKey:@"kTitleStringKey"];
        NSString *messageString = [notification.userInfo objectForKey:@"kMessageStringKey"];
        if (iconString) {
            titleString = [NSString stringWithFormat:@"%@ %@",iconString,titleString];
        }
        
        viewAlarmAlertView.message = messageString;
        viewAlarmAlertView.title = titleString;
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
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
    NSLog(@"didFinishLaunchingWithOptions ");
	
    [application registerNotifications];
	[YCSystemStatus sharedSystemStatus]; //一定要有这个初始化
    
    [IARegionsCenter sharedRegionCenter];
    locationManager = [[IALocationAlarmManager alloc] initWithDelegate:self];
    
    
    self.window.backgroundColor = [UIColor clearColor]; //为了自定义状态栏
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];	
	
	
	//不停止其他程序的音乐播放
	NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
    //[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    
    BOOL didReceiveLaunchIAlarmLocalNotification = NO; //收到了启动通知
    id theLocalNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    //因为响应本地通知到达而启动的
    if (theLocalNotification) { //第一种情况：程序因响应本地通知的到达而启动
        didReceiveLaunchIAlarmLocalNotification = [self didReceiveLaunchIAlarmLocalNotification:theLocalNotification];
        if (!didReceiveLaunchIAlarmLocalNotification) { //不是是定时启动通知
            [self setAlarmNotificationWithLocalNotification:theLocalNotification];
        }
    }else{//第二种情况：程序直接启动
        indexForView = 0;
    }
    animatedView = NO;
    
    //初始化中心数据
    if (didReceiveLaunchIAlarmLocalNotification) {
        [self checkAlarmsForAdd]; //有界面提示，尽快闹钟提醒原则。
    }else {
        CLLocation *lastLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
        [[IARegionsCenter sharedRegionCenter] checkAlarmsForAddWithCurrentLocation:lastLocation];
    }
    
    //debug
    //[[IARegionsCenter sharedRegionCenter] debug];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

	//失去了活动就别唱了
	[self.ringplayer stop];
	[self.vibratePlayer stop];
    
    //
    application.applicationIconBadgeNumber = 0;
    [[IAAlarmNotificationCenter defaultCenter] removeFiredNotification];
    
    //关闭未关闭的对话框
    [viewAlarmAlertView dismissWithClickedButtonIndex:viewAlarmAlertView.cancelButtonIndex animated:NO];
    [confirmRateAlertView dismissWithClickedButtonIndex:confirmRateAlertView.cancelButtonIndex animated:NO];
    [self.locationServicesUsableAlert cancelAlertWithAnimated:NO];
    
    //第四种情况：程序直接进入。在这里设置需要的参数
    indexForView = 0;
    animatedView = YES;
 
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [application performSelector:@selector(setApplicationIconBadgeNumber:) withInteger:0 afterDelay:0.1];//为评分判断留时间

	BOOL alreadyRate = [YCSystemStatus sharedSystemStatus].alreadyRate;
	BOOL notToRemindRate = [YCSystemStatus sharedSystemStatus].notToRemindRate;

	//没有评过 且 没点过不再提示 且 (闹钟提示过一次 或 每启动x次)
	BOOL letAlertShow = (!alreadyRate) && (!notToRemindRate) && ( application.applicationIconBadgeNumber > 0 );//没有评过 且 没点过不再提示 且 提醒过
	
    NSInteger applicationDidBecomeActiveNumber = application.numberOfApplicationDidBecomeActive;
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
        
        [confirmRateAlertView showWaitUntilBecomeKeyWindow:self.window afterDelay:4.0];
	}
    
    [self performBlock:^{
        //第一次系统会提示的 && 如果系统正在提示(就当是在提示开启定位)
        if (/*application.applicationDidFinishLaunchNumber > 1 &&*/ application.applicationState == UIApplicationStateActive) 
            [self.locationServicesUsableAlert showWaitUntilBecomeKeyWindow:self.window afterDelay:0.1];//检测定位服务状态。如果不可用或未授权，弹出对话框
    } afterDelay:2.0];
    
    //检测是否有要启动的alarm。因为第一次启动时候 IARegionsCenter初始化会执行这个了，第一次启动不需要
    if (application.numberOfApplicationDidBecomeActiveOnceLaunching > 0) {
        [self checkAlarmsForAdd];
        //debug
        //[[IARegionsCenter sharedRegionCenter] debug];
    }
    
    //打开查看视图
    [self viewNotificationedAlarm:animatedView];
    
    //取消通知，不然通知可能反复出现
    [self performBlock:^{
        for (UILocalNotification *aLn in application.scheduledLocalNotifications) {
            NSString *notificationId = [aLn.userInfo objectForKey:@"knotificationId"];
            if (notificationId) {
                [application cancelLocalNotification:aLn];
            }
        }
    } afterDelay:1.0];

}

- (void)checkApplicationScheduledLocalNotifications{
    //NSLog(@"checkApplicationScheduledLocalNotifications");
    //取消遗漏而无效的启动通知
    for (UILocalNotification *aNo in [UIApplication sharedApplication].scheduledLocalNotifications) {
        NSString *alarmId = [aNo.userInfo objectForKey:@"kLaunchIAlarmLocalNotificationKey"];
        if (alarmId != nil) { //是定时启动
            IAAlarm *anAlarm = [IAAlarm findForAlarmId:alarmId];
            if (nil == anAlarm || !anAlarm.enabled) //没有这个闹钟 或 闹钟关闭了
                [[UIApplication sharedApplication] cancelLocalNotification:aNo];
            
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do the work associated with the task, preferably in chunks.
        [self performSelectorOnMainThread:@selector(checkApplicationScheduledLocalNotifications) withObject:nil waitUntilDone:YES];
    
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
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
    [viewController release];
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
			[YCSystemStatus sharedSystemStatus].alreadyRate = YES;
			NSString *str = [NSString stringWithFormat: 
							 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppStoreAppID]; 
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
			
		}else if (buttonIndex == 2){//Not to remind 
			[YCSystemStatus sharedSystemStatus].notToRemindRate = YES;
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

    
    IAAlarm *alarmForNotif = region.alarm;
    
    //保存到文件
    IAAlarmNotification *alarmNotification = [[[IAAlarmNotification alloc] initWithAlarm:alarmForNotif] autorelease];
    [[IAAlarmNotificationCenter defaultCenter] addNotification:alarmNotification];
    
    //发本地通知
    NSString *promptTemple = arrived?kAlertFrmStringArrived:kAlertFrmStringLeaved;
    
    NSString *alarmName = alarmForNotif.alarmName ? alarmForNotif.alarmName : alarmForNotif.positionTitle;
    NSString *alertTitle = [[[NSString alloc] initWithFormat:promptTemple,alarmName,0.0] autorelease];
    NSString *alarmMessage = [alarmForNotif.notes stringByTrim];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:alarmNotification.notificationId forKey:@"knotificationId"];
    [userInfo setObject:alertTitle forKey:@"kTitleStringKey"];
    if (alarmMessage) 
        [userInfo setObject:alarmMessage forKey:@"kMessageStringKey"];
    
    NSString *iconString = nil;//这是铃铛🔔
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) 
        iconString = @"\U0001F514";
    else 
        iconString = @"\ue325";
    
    alertTitle =  [NSString stringWithFormat:@"%@ %@",iconString,alertTitle]; 
    [userInfo setObject:iconString forKey:@"kIconStringKey"];
    
    
    NSString *notificationBody = alertTitle;
    if (alarmMessage && alarmMessage.length > 0) {
        notificationBody = [NSString stringWithFormat:@"%@: %@",alertTitle,alarmMessage];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    NSInteger badgeNumber = app.applicationIconBadgeNumber + 1; //角标数
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = alarmForNotif.sound.soundFileName;
    notification.alertBody = notificationBody;
    notification.applicationIconBadgeNumber = badgeNumber;
    notification.userInfo = userInfo;
    notification.repeatInterval = NSMinuteCalendarUnit; //反复提示
    [app scheduleLocalNotification:notification];
    //[app presentLocalNotificationNow:notification];

}

- (void)locationManager:(IALocationAlarmManager *)manager didEnterRegion:(IARegion *)region
{
	IAAlarm *alarm = region.alarm;
	if ([alarm.positionType.positionTypeId isEqualToString:@"p001"]) { //是 “离开时候”提醒
		return; 
	}


    //加入到列表中
    //YCSystemStatus *systmStaus = [YCSystemStatus deviceStatusSingleInstance];
    //[systmStaus.localNotificationIdentifiers addObject:region.alarm.alarmId];
    
	[self alertRegion:region arrived:YES atCurrentLocation:manager.location];
	
	//只闹一次
	if ([alarm.repeatType.repeatTypeId isEqualToString:@"r001"]) 
	{
		alarm.enabled = NO;
		[alarm saveFromSender:self];
	}
	
}

- (void)locationManager:(IALocationAlarmManager *)manager didExitRegion:(IARegion *)region
{	
	//关闭离开通知
	//if([YCParam paramSingleInstance].closeLeaveNotify) return;

	IAAlarm *alarm = region.alarm;
	if ([alarm.positionType.positionTypeId isEqualToString:@"p002"]) { //是 “到达时候”提醒
		return; 
	}
	
	
    //加入到列表中
    //YCSystemStatus *systmStaus = [YCSystemStatus deviceStatusSingleInstance];
    //[systmStaus.localNotificationIdentifiers addObject:region.alarm.alarmId];
    
	[self alertRegion:region arrived:NO atCurrentLocation:manager.location];
	
	//只闹一次
	if ([alarm.repeatType.repeatTypeId isEqualToString:@"r001"]) 
	{
		alarm.enabled = NO;
		[alarm saveFromSender:self];
	}

}

#pragma mark -
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	[self.vibratePlayer stop];
}


@end

