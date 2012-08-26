//
//  LocalizedString.h
//  iAlarm
//
//  Created by li shiyong on 10-11-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//界面元素

/////////////////////////////////////////////////////////////////////////////////////
//视图的名称
#define KViewTitleAlarmsList                     NSLocalizedString(@"KViewTitleAlarmsList",                      @"闹钟列表视图标题")
#define KViewTitleAlarmsListMaps                 NSLocalizedString(@"KViewTitleAlarmsListMaps",                  @"闹钟地图视图标题")
#define KViewTitleInformation                    NSLocalizedString(@"KViewTitleInformation",                     @"信息卡视图标题")
#define KViewTitleAddAlarms                      NSLocalizedString(@"KViewTitleAddAlarms",                       @"添加闹钟视图标题")
#define KViewTitleEditAlarms                     NSLocalizedString(@"KViewTitleEditAlarms",                      @"编辑闹钟视图标题")
#define KViewTitleRepeat                         NSLocalizedString(@"KViewTitleRepeat",                          @"编辑重复类型视图标题")
#define KViewTitleSound                          NSLocalizedString(@"KViewTitleSound",                           @"编辑铃声视图标题")
#define KViewTitleName                           NSLocalizedString(@"KViewTitleName",                            @"编辑名称视图标题")
#define KViewTitleVibrate                        NSLocalizedString(@"KViewTitleVibrate",                         @"编辑名称视图标题")
#define KViewTitleAlarmRadius                    NSLocalizedString(@"KViewTitleAlarmRadius",                     @"编辑警示半径视图标题")
#define KViewTitleAlarmPostion                   NSLocalizedString(@"KViewTitleAlarmPostion",                    @"编辑地址的视图标题")
#define KViewTitleMapBookmarks                   NSLocalizedString(@"KViewTitleMapBookmarks",                    @"地图书签视图的标题")
#define KViewTitleTrigger                        NSLocalizedString(@"KViewTitleTrigger",                         @"触发警告条件视图的标题")


/////////////////////////////////////////////////////////////////////////////////////
//标签
#define KLabelAlarmEnable                        NSLocalizedString(@"KLabelAlarmEnable",                         @"Alarm是否启用的标签")
#define KLabelAlarmRepeat                        NSLocalizedString(@"KLabelAlarmRepeat",                         @"重复类型的标签")
#define KLabelAlarmSound                         NSLocalizedString(@"KLabelAlarmSound",                          @"声音的标签")
#define KLabelAlarmName                          NSLocalizedString(@"KLabelAlarmName",                           @"闹钟名字的标签")
#define KLabelAlarmVibrate                       NSLocalizedString(@"KLabelAlarmVibrate",                        @"振动的标签")
#define KLabelAlarmRadius                        NSLocalizedString(@"KLabelAlarmRadius",                         @"警示半径的标签")
#define KLabelAlarmPostion                       NSLocalizedString(@"KLabelAlarmPostion",                        @"地址的标签")
#define KLabelAlarmMapInfo                       NSLocalizedString(@"KLabelAlarmMapInfo",                        @"信息卡视图地址的标签（英文小写）")
#define KLabelMapNewAnnotationTitle              NSLocalizedString(@"KLabelMapNewAnnotationTitle",               @"新增闹钟的大头针的标题")
#define KLabelMapBookmarksView                   NSLocalizedString(@"KLabelMapBookmarksView",                    @"地图书签视图的提示文本")
#define KLabelAlarmTrigger                       NSLocalizedString(@"KLabelAlarmTrigger",                        @"触发警告条件的标签")


/////////////////////////////////////////////////////////////////////////////////////
//tab的名称
#define KTabTitleAlarmList                       NSLocalizedString(@"KTabTitleAlarmList",                        @"闹钟列表tab标题")
#define KTabTitleAlarmMaps                       NSLocalizedString(@"KTabTitleAlarmMaps",                        @"闹钟地图tab标题")
#define KTabTitleSetting                         NSLocalizedString(@"KTabTitleSetting",                          @"设置tab的标题")
#define KTabTitleAbout                           NSLocalizedString(@"KTabTitleAbout",                            @"关于tab的标题")

/////////////////////////////////////////////////////////////////////////////////////
//界面的文本内容
#define KTextPromptNoiAlarms                     NSLocalizedString(@"KTextPromptNoiAlarms",                      @"空闹钟列表的背景文字")
#define KTextPromptWhenLocating                  NSLocalizedString(@"KTextPromptWhenLocating",                   @"正在定位的提示文本")
#define KTextPromptWhenReversing                 NSLocalizedString(@"KTextPromptWhenReversing",                  @"正在反转地址的提示文本")
#define KTextPromptNeedInternetToReversing       NSLocalizedString(@"KTextPromptNeedInternetToReversing",        @"提示无法反转地址，需要打开internet连接的提示文本")         
#define KTextPromptNeedSetLocationByMaps         NSLocalizedString(@"KTextPromptNeedSetLocationByMaps",          @"提示无法取得当前位置，需要通过地图指定位置的提示文本")
#define KTextPromptWhenLoading                   NSLocalizedString(@"KTextPromptWhenLoading",                    @"正在载入的提示文本")

#define KTextPromptDistanceCurrentLocation       NSLocalizedString(@"KTextPromptDistanceCurrentLocation",        @"距离当前位置xx公里的文本")
#define KTextPromptCurrentLocation               NSLocalizedString(@"KTextPromptCurrentLocation",                @"当前位置的文本")
#define KTextPromptItIsCurrentLocation           NSLocalizedString(@"KTextPromptItIsCurrentLocation",            @"这是当前位置的文本")                          
#define KTextPromptPlaceholderOfSearchBar        NSLocalizedString(@"KTextPromptPlaceholderOfSearchBar",         @"搜索bar的Placeholder")                          


/////////////////////////////////////////////////////////////////////////////////////
//字典

#define KDefaultAlarmName                        NSLocalizedString(@"KDefaultAlarmName",                         @"默认的位置闹钟名称")
#define KDicMapTypeNameStandard                  NSLocalizedString(@"KDicMapTypeNameStandard",                   @"标准地图类型名称")
#define KDicMapTypeNameSatellite                 NSLocalizedString(@"KDicMapTypeNameSatellite",                  @"卫星地图类型名称")
#define KDicMapTypeNameHybrid                    NSLocalizedString(@"KDicMapTypeNameHybrid",                     @"混合地图类型名称")

//重复类型的名称
#define KDicRepeateTypeName001                   NSLocalizedString(@"KDicRepeateTypeName001",                    @"重复类型的名称-001，Forever")
#define KDicRepeateTypeName002                   NSLocalizedString(@"KDicRepeateTypeName002",                    @"重复类型的名称-002，Once")

//警示半径类型名称
#define KDicAlarmRadius001                       NSLocalizedString(@"KDicAlarmRadius001",                        @"警示半径类型名称-001，Near")
#define KDicAlarmRadius002                       NSLocalizedString(@"KDicAlarmRadius002",                        @"警示半径类型名称-002，Standard")
#define KDicAlarmRadius003                       NSLocalizedString(@"KDicAlarmRadius003",                        @"警示半径类型名称-003，Far")
#define KDicAlarmRadius004                       NSLocalizedString(@"KDicAlarmRadius004",                        @"警示半径类型名称-004，Custom")

//开关
#define KDicOn                                   NSLocalizedString(@"KDicOn",                                    @"开关值已经打开")
#define KDicOff                                  NSLocalizedString(@"KDicOff",                                   @"开关值已经关闭")

//触发条件类型的名称
#define kDicTriggerTypeNameWhenArrive            NSLocalizedString(@"kDicTriggerTypeNameWhenArrive",             @"触发条件类型的名称，When I Arrive")
#define kDicTriggerTypeNameWhenLeave             NSLocalizedString(@"kDicTriggerTypeNameWhenLeave",              @"触发条件类型的名称，When I Leave")


/////////////////////////////////////////////////////////////////////////////////////
//提示框

//alert通用按钮
#define kAlertBtnOK                              NSLocalizedString(@"kAlertBtnOK",                               @"OK按钮")
#define kAlertBtnCancel                          NSLocalizedString(@"kAlertBtnCancel",                           @"Cancel按钮")
#define kAlertBtnRetry                           NSLocalizedString(@"kAlertBtnRetry",                            @"Retry按钮")
#define kAlertBtnSettings                        NSLocalizedString(@"kAlertBtnSettings",                         @"Settings按钮")
#define kAlertBtnView                            NSLocalizedString(@"kAlertBtnView",                             @"查看按钮")
#define kAlertBtnClose                           NSLocalizedString(@"kAlertBtnClose",                            @"关闭按钮")
#define kAlertBtnUpgrade                         NSLocalizedString(@"kAlertBtnUpgrade",                          @"升级按钮")



//地址查询提示标题
#define kAlertSearchTitle                        NSLocalizedString(@"kAlertSearchTitle",                         @"查询提示框标题，Search")
#define kAlertSearchTitleResults                 NSLocalizedString(@"kAlertSearchTitleResults",                  @"查询完成，有多个结果提示用户选择，Did you mean...")
#define kAlertSearchTitleNoResults               NSLocalizedString(@"kAlertSearchTitleNoResults",                @"地址查询失败的提示框标题：无结果，No Results Found")
#define kAlertSearchTitleTooManyQueries          NSLocalizedString(@"kAlertSearchTitleTooManyQueries",           @"地址查询失败的提示框标题：一天内查询次数过多，Too Many Queries has been Made")
#define kAlertSearchTitleDefaultError            NSLocalizedString(@"kAlertSearchTitleDefaultError",             @"地址查询失败的提示框标题：发生网络错误，Network Error，（错误的默认提示）")

//地址查询提示内容
#define kAlertSearchBodyTryAgain                 NSLocalizedString(@"kAlertSearchBodyTryAgain",                  @"查询失败的提示框内容：请重试。Please try again.（错误的默认提示）")
#define kAlertSearchBodyTryTomorrow              NSLocalizedString(@"kAlertSearchBodyTryTomorrow",               @"查询失败的提示框内容：Please try tomorrow.对应“一天内查询次数过多”")


//到达或离开的提示内容
#define kAlertFrmStringArrived                   NSLocalizedString(@"kAlertFrmStringArrived",                    @"xx即将到达，xx is coming.")
#define kAlertFrmStringLeaved                    NSLocalizedString(@"kAlertFrmStringLeaved",                     @"xx已经离开，Leave xx")

//提示需要网络
#define kAlertNeedInternetTitleAccessMaps        NSLocalizedString(@"kAlertNeedInternetTitleAccessMaps",         @"需要打开internet连接访问地图的提示框的标题")
#define kAlertNeedInternetBodyAccessMaps         NSLocalizedString(@"kAlertNeedInternetBodyAccessMaps",          @"需要打开internet连接访问地图的提示框的内容")
#define kAlertNeedInternetTitleAccessAppStore    NSLocalizedString(@"kAlertNeedInternetTitleAccessAppStore",     @"需要打开internet连接访问App store的提示框的标题")
#define kAlertNeedInternetBodyAccessAppStore     NSLocalizedString(@"kAlertNeedInternetBodyAccessAppStore",      @"需要打开internet连接访问App store的提示框的内容")



//提示需要定位服务
#define kAlertNeedLocationServicesTitle          NSLocalizedString(@"kAlertNeedLocationServicesTitle",           @"打开定位服务的提示框的消息标题")
#define kAlertNeedLocationServicesBody           NSLocalizedString(@"kAlertNeedLocationServicesBody",            @"打开定位服务的提示框的消息内容")

//提示升级为pro版本
#define kAlertUpgradeProVesionTitle              NSLocalizedString(@"kAlertUpgradeProVesionTitle",               @"升级为pro版本的提示框的消息标题")
#define kAlertUpgradeProVesionBody               NSLocalizedString(@"kAlertUpgradeProVesionBody",                @"升级为pro版本的提示框的消息内容")

//提示购买
#define kAlertPurchaseTitle                      NSLocalizedString(@"kAlertPurchaseTitle",                       @"购买的消息标题")
#define kAlertPurchasenNotAllowPurchaseBody      NSLocalizedString(@"kAlertPurchasenNotAllowPurchaseBody",       @"需要打开允许购买选项的消息标题")


/////////////////////////////////////////////////////////////////////////////////////
//数量单位
#define kUnitMeters                              NSLocalizedString(@"kUnitMeters",                               @"米(复数)")
#define kUnitMeter                               NSLocalizedString(@"kUnitMeter",                                @"米(单数)")
#define kUnitKilometre                           NSLocalizedString(@"kUnitKilometre",                            @"千米(单数)")


/////////////////////////////////////////////////////////////////////////////////////
//经纬度转换 41°46′21″N  、 41°46′21.12″N

#define kCoordinateFrmStringEastLongitude              NSLocalizedString(@"kCoordinateFrmStringEastLongitude",       @"东经格式化串")
#define kCoordinateFrmStringEastLongitudeSpace         NSLocalizedString(@"kCoordinateFrmStringEastLongitudeSpace",  @"东经格式化串(值与符号间有空格)")
#define kCoordinateFrmStringEastLongitudeDecimal       NSLocalizedString(@"kCoordinateFrmStringEastLongitudeDecimal",@"东经格式化串(秒上带小数)")

#define kCoordinateFrmStringNorthLatitude              NSLocalizedString(@"kCoordinateFrmStringNorthLatitude",       @"北纬格式化串")
#define kCoordinateFrmStringNorthLatitudeSpace         NSLocalizedString(@"kCoordinateFrmStringNorthLatitudeSpace",  @"北纬格式化串(值与符号间有空格)")
#define kCoordinateFrmStringNorthLatitudeDecimal       NSLocalizedString(@"kCoordinateFrmStringNorthLatitudeDecimal",@"北纬格式化串(秒上带小数)")

#define kCoordinateFrmStringSouthLatitude              NSLocalizedString(@"kCoordinateFrmStringSouthLatitude",       @"南纬格式化串")
#define kCoordinateFrmStringSouthLatitudeSpace         NSLocalizedString(@"kCoordinateFrmStringSouthLatitudeSpace",  @"南纬格式化串(值与符号间有空格)")
#define kCoordinateFrmStringSouthLatitudeDecimal       NSLocalizedString(@"kCoordinateFrmStringSouthLatitudeDecimal",@"南纬格式化串(秒上带小数)")

#define kCoordinateFrmStringWestLongitude              NSLocalizedString(@"kCoordinateFrmStringWestLongitude",       @"西经格式化串")
#define kCoordinateFrmStringWestLongitudeSpace         NSLocalizedString(@"kCoordinateFrmStringWestLongitudeSpace",  @"西经格式化串(值与符号间有空格)")
#define kCoordinateFrmStringWestLongitudeDecimal       NSLocalizedString(@"kCoordinateFrmStringWestLongitudeDecimal",@"西经格式化串(秒上带小数)")

//////////////////////////////////////////////////////

#define KAPTextPlaceholderNote                     NSLocalizedString(@"KAPTextPlaceholderNote",                  @"备注的提示文本")
#define KAPTextPlaceholderName                     NSLocalizedString(@"KAPTextPlaceholderName",                  @"名字的提示文本")
#define KAPTitleNote                               NSLocalizedString(@"KAPTitleNote",                            @"备注")
#define KAPTitleTimeSwitch                         NSLocalizedString(@"KAPTitleTimeSwitch",                      @"定时启动")
#define KAPTitleBeginTime                          NSLocalizedString(@"KAPTitleBeginTime",                       @"开始")
#define KAPTitleEndTime                            NSLocalizedString(@"KAPTitleEndTime",                         @"结束")
#define KAPTitleSameBeginEndTime                   NSLocalizedString(@"KAPTitleSameBeginEndTime",                @"开始结束时间相同")
#define KAPTitleBeginTimeAndEndTime                NSLocalizedString(@"KAPTitleBeginTimeAndEndTime",             @"开始与结束")

#define KWDSTitleEveryDay                          NSLocalizedString(@"KWDSTitleEveryDay",                       @"每天")
#define KWDSTitleWeekdays                          NSLocalizedString(@"KWDSTitleWeekdays",                       @"工作日")
#define KWDSTitleWeekends                          NSLocalizedString(@"KWDSTitleWeekends",                       @"周末")
#define KWDSTitleNextDay                           NSLocalizedString(@"KWDSTitleNextDay",                        @"次日")

#define KWDTitleEveryMonday                        NSLocalizedString(@"KWDTitleEveryMonday",                     @"每周一")
#define KWDTitleEveryTuesday                       NSLocalizedString(@"KWDTitleEveryTuesday",                    @"每周二")
#define KWDTitleEveryWednesday                     NSLocalizedString(@"KWDTitleEveryWednesday",                  @"每周三")
#define KWDTitleEveryThursday                      NSLocalizedString(@"KWDTitleEveryThursday",                   @"每周四")
#define KWDTitleEveryFriday                        NSLocalizedString(@"KWDTitleEveryFriday",                     @"每周五")
#define KWDTitleEverySaturday                      NSLocalizedString(@"KWDTitleEverySaturday",                   @"每周六")
#define KWDTitleEverySunday                        NSLocalizedString(@"KWDTitleEverySunday",                     @"每周日")

#define KTITitleNow                                NSLocalizedString(@"KTITitleNow",                             @"现在")
#define KTITitleXMAgo                              NSLocalizedString(@"KTITitleXMAgo",                           @"x分钟前")
#define KTITitleXHAgo                              NSLocalizedString(@"KTITitleXHAgo",                           @"x小时前")
#define KTITitleXDAgo                              NSLocalizedString(@"KTITitleXDAgo",                           @"x天前")

#define KBMTitleContacts                           NSLocalizedString(@"KBMTitleContacts",                        @"通讯录")
#define KBMTitleContact                            NSLocalizedString(@"KBMTitleContact",                         @"联系人")
#define KBMTitleBMRecents                          NSLocalizedString(@"KBMTitleBMRecents",                       @"最近搜索")
#define KBMTitlePromptContacts                     NSLocalizedString(@"KBMTitlePromptContacts",                  @"选取联系人显示在地图上")
#define KBMTitlePromptRecents                      NSLocalizedString(@"KBMTitlePromptRecents",                   @"选取最近的搜索")

#define kTitleTellFriends                          NSLocalizedString(@"kTitleTellFriends",                       @"告诉朋友")
#define kTitleAlarmAfterXMinutes                   NSLocalizedString(@"kTitleAlarmAfterXMinutes",                @"过X分钟提醒")
#define kTitleAlarmLater                           NSLocalizedString(@"kTitleAlarmLater",                        @"过一会再提醒")
#define KTitleClearAllRecents                      NSLocalizedString(@"KTitleClearAllRecents",                   @"清除所有最近搜索")

#define KTextDistanceLessThan0_1Km                 NSLocalizedString(@"KTextDistanceLessThan0_1Km",              @"距离当前位置:少于0.1公里")
#define KTextWhyTimeSwitch                         NSLocalizedString(@"KTextWhyTimeSwitch",                      @"为什么要实用定时启动的描述")
#define KTextWaringRadiusTooSmall                  NSLocalizedString(@"KTextWaringRadiusTooSmall",               @"闹钟半径太小的警告")
#define KTextWaringNexttimeAlarm                   NSLocalizedString(@"KTextWaringNexttimeAlarm",                @"下一次提醒的警告")
#define KTextNotificationLaunchAlarm               NSLocalizedString(@"KTextNotificationLaunchAlarm",            @"启动位置闹钟的通知")
#define KTextAlarmHasLaunched                      NSLocalizedString(@"KTextAlarmHasLaunched",                   @"已启动！")
#define KTextWhyCanNotAutoLaunch                   NSLocalizedString(@"KTextWhyCanNotAutoLaunch",                @"不能自动启动的原因")

