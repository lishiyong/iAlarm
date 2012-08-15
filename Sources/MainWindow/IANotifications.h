//
//  AlarmListNotification.h
//  iAlarm
//
//  Created by li shiyong on 11-4-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//////////////////////////////////
//标准定位结束通知
extern NSString *IAStandardLocationDidFinishNotification;
//标准定位结束通知中定位数据的key
extern NSString *IAStandardLocationKey;
//////////////////////////////////


//发送通知时间的key
extern NSString *IASendNotifyTimestampKey;


//list与maps视图转换通知
extern NSString *IAListViewMapsViewSwitchNotification;


//增加alarm按钮被按通知
extern NSString *IAAddIAlarmButtonPressedNotification;
//被增加的Alarm的key
extern NSString *IAAlarmAddedKey;


//编辑alarm按钮被按通知
extern NSString *IAEditIAlarmButtonPressedNotification;
//被编辑alarm的key
extern NSString *IAEditIAlarmButtonPressedNotifyAlarmObjectKey;


//info按钮被按通知
extern NSString *IAInfoButtonPressedNotification;


//当前位置按钮被按通知
extern NSString *IACurrentLocationButtonPressedNotification;


//聚焦按钮被按通知
extern NSString *IAFocusButtonPressedNotification;


//地图类型按钮被按通知
extern NSString *IAMapTypeButtonPressedNotification;



//闹钟列表的编辑状态改变了
extern NSString *IAAlarmListEditStateDidChangeNotification;
//编辑状态的key
extern NSString *IAEditStatusKey;


//通知闹钟地图，使至少有一个pin可视，并选中
extern NSString *IALetAlarmMapsViewHaveAPinVisibleAndSelectedNotification;


//通知闹钟地图的mask状态改变了
extern NSString *IAAlarmMapsMaskingDidChangeNotification;
//mask状态key
extern NSString *IAAlarmMapsMaskingKey;


//闹钟到达或离开通知用户
extern NSString *IAAlarmDidAlertNotification;


//查看了到达或离开的闹钟通知
extern NSString *IAAlarmDidViewNotification;
//被查看闹钟的key
extern NSString * IAViewedAlarmKey;


//要求改变控件可用状态的通知
extern NSString *IAControlStatusShouldChangeNotification;
//控件Id key。value是整型。
//约定：(BackgroundViewController.currentLocationBarButtonItem) = 1 
//     (BackgroundViewController.focusBarButtonItem) = 2
extern NSString *IAControlIdKey;
//控件状态值 key。value是BOOL型
extern NSString *IAControlStatusKey; 


//区域类型改变了的通知
extern NSString *IARegionTypeDidChangeNotification;
//被改变的区域闹钟的key
extern NSString *IAChangedRegionKey;

//隐藏或显示bar的通知
extern NSString *IADoHideBarNotification;
//BOOL参数，YES:隐藏，NO：显示
extern NSString *IADoHideBarKey;

//改变了skin的类型的通知
extern NSString *IASkinStyleDidChange;
//
extern NSString *IASkinStyleKey;
