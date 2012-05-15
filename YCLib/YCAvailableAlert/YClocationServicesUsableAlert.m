//
//  YCAvailableAlert.m
//  iAlarm
//
//  Created by li shiyong on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCSystemStatus.h"
#import "UIUtility.h"
#import "YClocationServicesUsableAlert.h"


@implementation YClocationServicesUsableAlert

- (CLLocationManager *)locationManager{
	if (locationManager == nil) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	return locationManager;
}

#pragma mark - 
#pragma mark - CLLocationManagerDelegate 
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	[manager stopUpdatingLocation];
	//定位服务已经开启，并授权
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	[manager stopUpdatingLocation];
	
	//定位服务已经开启，但未授权
	if ([error code] == 1 && !isAlreadyAlert)  //error code == 1是未授权
	{
		[UIUtility simpleAlertBody:kAlertNeedLocationServicesBody alertTitle:kAlertNeedLocationServicesTitle cancelButtonTitle:kAlertBtnOK delegate:nil];
		isAlreadyAlert = YES;
	}
	
}


//检测定位服务状态。如果不可用或未授权，弹出对话框
- (void)locationServicesUsable{
	
	//检查定位服务
	BOOL enabledLocation = [[YCSystemStatus deviceStatusSingleInstance] enabledLocation];
	if (enabledLocation) {
		if (![CLLocationManager respondsToSelector:@selector(authorizationStatus)]) //iOS4.2版本后才支持
		{
			isAlreadyAlert = NO;
			[self.locationManager startUpdatingLocation];
			[self.locationManager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:3.0];//约定关闭，防止不能被关闭
		}else{
			enabledLocation = ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorized);
		}
	}
	
	if (!enabledLocation) {

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            // iOS 5 code
            if (!alert) 
                alert = [[UIAlertView alloc] initWithTitle:kAlertNeedLocationServicesTitle
                                                   message:kAlertNeedLocationServicesBody 
                                                  delegate:self
                                         cancelButtonTitle:kAlertBtnSettings
                                         otherButtonTitles:kAlertBtnCancel,nil];
            
           

        }else {
            // iOS 4.x code
            [UIUtility simpleAlertBody:kAlertNeedLocationServicesBody alertTitle:kAlertNeedLocationServicesTitle cancelButtonTitle:kAlertBtnOK delegate:nil];
            
            if (!alert) 
                alert = [[UIAlertView alloc] initWithTitle:kAlertNeedLocationServicesTitle
                                                   message:kAlertNeedLocationServicesBody 
                                                  delegate:nil
                                         cancelButtonTitle:kAlertBtnOK
                                         otherButtonTitles:nil];
                                         
            
        }
        
        [alert show];

        
	}
}

- (void)cancelAlertWithAnimated:(BOOL)animated{
    NSInteger cancelButtonIndex = alert.cancelButtonIndex;
    [alert dismissWithClickedButtonIndex:cancelButtonIndex animated:animated];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kAlertBtnSettings]) {
        NSString *str = @"prefs:root=LOCATION_SERVICES"; //打开设置中的定位
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)dealloc {
	[locationManager release];
    [alert release];
    [super dealloc];
}

@end
