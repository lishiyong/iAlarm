//
//  AlarmListNotification.m
//  iAlarm
//
//  Created by li shiyong on 11-2-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IANotifications.h"

//////////////////////////////////
//标准定位结束
NSString *IAStandardLocationDidFinishNotification = @"IAStandardLocationDidFinishNotification";
//标准定位结束通知中定位数据的key
NSString *IAStandardLocationKey = @"IAStandardLocationKey";
//////////////////////////////////


//发送通知时间的key
NSString *IASendNotifyTimestampKey = @"IASendNotifyTimestampKey";


//list与maps视图转换通知
NSString *IAListViewMapsViewSwitchNotification = @"IAListViewMapsViewSwitchNotification";


//增加alarm按钮被按通知
NSString *IAAddIAlarmButtonPressedNotification = @"IAAddIAlarmButtonPressedNotification";
NSString *IAAlarmAddedKey = @"IAAlarmAddedKey";


//编辑alarm按钮被按通知
NSString *IAEditIAlarmButtonPressedNotification = @"IAEditIAlarmButtonPressedNotification";
//被编辑alarm的key
NSString *IAEditIAlarmButtonPressedNotifyAlarmObjectKey = @"IAEditIAlarmButtonPressedNotifyAlarmObjectKey";


//info按钮被按通知
NSString *IAInfoButtonPressedNotification = @"IAInfoButtonPressedNotification";


//当前位置按钮被按通知
NSString *IACurrentLocationButtonPressedNotification = @"IACurrentLocationButtonPressedNotification";


//聚焦按钮被按通知
NSString *IAFocusButtonPressedNotification = @"IAFocusButtonPressedNotification";


//地图类型按钮被按通知
NSString *IAMapTypeButtonPressedNotification = @"IAMapTypeButtonPressedNotification";


//闹钟列表的编辑状态改变了
NSString *IAAlarmListEditStateDidChangeNotification = @"IAAlarmListEditStateDidChangeNotification";
//编辑状态的key
NSString *IAEditStatusKey = @"IAEditStatusKey";


//通知闹钟地图，使至少有一个pin可视，并选中
NSString *IALetAlarmMapsViewHaveAPinVisibleAndSelectedNotification = @"IALetAlarmMapsViewHaveAPinVisibleAndSelectedNotification";



//通知闹钟地图的mask状态改变了
NSString *IAAlarmMapsMaskingDidChangeNotification = @"IAAlarmMapsMaskingDidChangeNotification";
//mask状态key
NSString *IAAlarmMapsMaskingKey = @"IAAlarmMapsMaskingKey";


//闹钟到达或离开通知用户
NSString *IAAlarmDidAlertNotification = @"IAAlarmDidAlertNotification";


//查看了到达或离开的闹钟通知
NSString *IAAlarmDidViewNotification = @"IAAlarmDidViewNotification";
//被查看闹钟的key
NSString *IAViewedAlarmKey = @"IAViewedAlarmKey";


//要求改变控件可用状态的通
NSString *IAControlStatusShouldChangeNotification = @"IAControlStatusShouldChangeNotification";
//控件Id key。value是整型。
//约定：(BackgroundViewController.currentLocationBarButtonItem) = 1 
//     (BackgroundViewController.focusBarButtonItem) = 2
NSString *IAControlIdKey = @"IAControlIdKey";
//控件状态值 key。value是BOOL型
NSString *IAControlStatusKey = @"IAControlStatusKey"; 


//区域类型改变了的通知
NSString *IARegionTypeDidChangeNotification = @"IARegionTypeDidChangeNotification";
//被改变的区域闹钟的key
NSString *IAChangedRegionKey = @"IAChangedRegionKey";

//隐藏或显示bar的通知
NSString *IADoHideBarNotification = @"IADoHideBarNotification";
//BOOL参数，YES:隐藏，NO：显示
NSString *IADoHideBarKey = @"IADoHideBarKey";



