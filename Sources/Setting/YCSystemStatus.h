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
	
	BOOL connectedToInternet;
	BOOL enabledLocation;                             //iOS4.2前：locationServicesEnabled的检测，判断授权需要 catch – locationManager:didFailWithError: 
						                              //iOS4.2后：包括对authorizationStatus的检测。
	
	CLLocation *lastLocation;                         //上次标准定位位置
	BOOL canValidLocation;                            //是否能有效定位，给不能定位图标等用。
    
    NSMutableArray *localNotificationIdentifiers;     //未查看的本地通知id
	
	BOOL isAlarmListEditing;                          //列表的编辑状态
	

}

@property (nonatomic,assign,readonly) BOOL connectedToInternet;
@property (nonatomic,assign,readonly) BOOL enabledLocation;
@property (nonatomic,retain) CLLocation *lastLocation;
@property (nonatomic,retain) NSMutableArray *localNotificationIdentifiers; 
@property (nonatomic,assign,readonly) BOOL canValidLocation; 
@property (nonatomic,assign) BOOL isAlarmListEditing;

@property (nonatomic,assign,readonly) NSInteger applicationDidFinishLaunchNumber;  //系统完成启动的次数
@property (nonatomic,assign,readonly) NSInteger applicationDidBecomeActiveNumber;  //进入到前台的次数
@property (nonatomic,assign,readonly) NSInteger alarmAlertNumber;                  //iAlarm发出通知的次数
//@property (nonatomic,assign)          NSInteger viewIndexWhenExit;                 //程序退出时候

@property (nonatomic) BOOL	alreadyRate; //是否已经评论过  
@property (nonatomic) BOOL	notToRemindRate; //是否不再评论  



+(YCSystemStatus*) deviceStatusSingleInstance;

@end
