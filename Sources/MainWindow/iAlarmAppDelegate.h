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


@class YCSoundPlayer;
@class YClocationServicesUsableAlert;
@class BackgroundViewController;
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
	
	
	//////////////////////////////
	//有区域到达
	IARegion *lastRegion;
	CLLocation *lastCurrentLocation;
	
	YClocationServicesUsableAlert *locationServicesUsableAlert;  //测定位服务用
	
	//要求评分的对话框
	UIAlertView *confirmRateAlertView;

	BOOL isResignActive;//是否曾经退到后台过
    NSUInteger indexForView;//查看的index
}

@property (nonatomic,retain) IBOutlet UIWindow *window;
//@property (nonatomic,retain) IBOutlet BackgroundViewController *viewController;
@property (nonatomic,retain) IBOutlet UINavigationController *navigationController;


//@property (nonatomic,retain,readonly) IALocationManager *locationManager;
//@property (nonatomic,retain,readonly) id<IALocationManagerInterface> locationManager;

@property (nonatomic,retain) YCSoundPlayer *soundPlayer;
@property (nonatomic,retain,readonly) YCSoundPlayer *vibratePlayer;
@property (nonatomic,retain) AVAudioPlayer *ringplayer;


@property (nonatomic,retain) IARegion *lastRegion;
@property (nonatomic,retain) CLLocation *lastCurrentLocation;

@property (nonatomic,retain,readonly) YClocationServicesUsableAlert *locationServicesUsableAlert;

@property (nonatomic,retain,readonly) UIAlertView *confirmRateAlertView;


@end
