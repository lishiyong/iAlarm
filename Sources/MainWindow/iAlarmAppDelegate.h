//
//  iAlarmAppDelegate.h
//  iAlarm
//
//  Created by li shiyong on 10-11-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "IALocationManagerDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class YCSoundPlayer, YClocationServicesUsableAlert, BackgroundViewController, IAAlarmNotification, IALocationAlarmManager;
@interface iAlarmAppDelegate : NSObject 
<UIApplicationDelegate,IALocationAlarmManagerDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate> 
{
    UIWindow *window;
	//BackgroundViewController *viewController;
	UINavigationController *viewController;

	
    IALocationAlarmManager *locationManager;

	
	YCSoundPlayer *soundPlayer ;
	YCSoundPlayer *vibratePlayer;
	AVAudioPlayer *ringplayer;
	
	YClocationServicesUsableAlert *locationServicesUsableAlert;  //测定位服务用
	
	UIAlertView *confirmRateAlertView;//要求评分的对话框
    UIAlertView *viewAlarmAlertView; //查看
    
    NSUInteger indexForView;//查看的index
    BOOL animatedView;
    IAAlarmNotification *alarmNotification_;
    
    UIBackgroundTaskIdentifier bgTask;
}

@property (nonatomic,retain) IBOutlet UIWindow *window;
//@property (nonatomic,retain) IBOutlet BackgroundViewController *viewController;
@property (nonatomic,retain) IBOutlet UINavigationController *viewController;


//@property (nonatomic,retain,readonly) IALocationManager *locationManager;
//@property (nonatomic,retain,readonly) id<IALocationManagerInterface> locationManager;

@property (nonatomic,retain) YCSoundPlayer *soundPlayer;
@property (nonatomic,retain,readonly) YCSoundPlayer *vibratePlayer;
@property (nonatomic,retain) AVAudioPlayer *ringplayer;


@property (nonatomic,retain,readonly) YClocationServicesUsableAlert *locationServicesUsableAlert;



@end
