//
//  YCDeviceStatus.h
//  iAlarm
//
//  Created by li shiyong on 10-11-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class Reachability;
@interface YCSystemStatus : NSObject {
	BOOL _isAlarmListEditing;                          //列表的编辑状态
	
	CLLocation *_lastLocation;                         //上次标准定位位置
    CLLocation *_lastWritedLocation;                  //最后被写入文件的
}

//iOS4.2前：locationServicesEnabled的检测，判断授权需要 catch – locationManager:didFailWithError: 
//iOS4.2后：包括对authorizationStatus的检测。
@property (nonatomic,assign,readonly) BOOL enabledLocation;

@property (nonatomic,assign,readonly) BOOL connectedToInternet;
@property (nonatomic,assign)          BOOL     isAlarmListEditing;
@property (nonatomic,retain)          CLLocation *lastLocation;
@property (nonatomic) BOOL	alreadyRate; //是否已经评论过  
@property (nonatomic) BOOL	notToRemindRate; //是否不再评论  


+(YCSystemStatus*) sharedSystemStatus;

@end
