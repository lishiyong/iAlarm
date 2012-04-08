//
//  iAlarmAppDelegate.h
//  iAlarm
//
//  Created by li shiyong on 10-11-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "IALocationManagerInterface.h"

@class YCSoundPlayer, YClocationServicesUsableAlert, BackgroundViewController, IAAlarmNotification;
@interface iAlarmAppDelegate : NSObject 
<UIApplicationDelegate,IALocationManagerDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate> 
{
    UIWindow *window;
	//BackgroundViewController *viewController;
	UINavigationController *navigationController;

	
	//IALocationManager *locationManager;
    id<IALocationManagerInterface> locationManager;

	
	YCSoundPlayer *soundPlayer ;
	YCSoundPlayer *vibratePlayer;
	AVAudioPlayer *ringplayer;
	
	YClocationServicesUsableAlert *locationServicesUsableAlert;  //测定位服务用
	
	//要求评分的对话框
	UIAlertView *confirmRateAlertView;
    UIAlertView *viewAlarmAlertView;
    

    NSUInteger indexForView;//查看的index
    BOOL animatedView;
    IAAlarmNotification *alarmNotification_;
}

@property (nonatomic,retain) IBOutlet UIWindow *window;
//@property (nonatomic,retain) IBOutlet BackgroundViewController *viewController;
@property (nonatomic,retain) IBOutlet UINavigationController *navigationController;


//@property (nonatomic,retain,readonly) IALocationManager *locationManager;
//@property (nonatomic,retain,readonly) id<IALocationManagerInterface> locationManager;

@property (nonatomic,retain) YCSoundPlayer *soundPlayer;
@property (nonatomic,retain,readonly) YCSoundPlayer *vibratePlayer;
@property (nonatomic,retain) AVAudioPlayer *ringplayer;


@property (nonatomic,retain,readonly) YClocationServicesUsableAlert *locationServicesUsableAlert;



@end
