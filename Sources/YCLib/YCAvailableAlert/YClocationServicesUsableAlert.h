//
//  YCAvailableAlert.h
//  iAlarm
//
//  Created by li shiyong on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface YClocationServicesUsableAlert : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;                     //4.2版本前检测定位服务用
	
	BOOL isAlreadyAlert;  //是否已经提示过了
}

@property (nonatomic,retain,readonly) CLLocationManager *locationManager;

//检测定位服务状态。如果不可用或未授权，弹出对话框
- (void)locationServicesUsable;

@end
