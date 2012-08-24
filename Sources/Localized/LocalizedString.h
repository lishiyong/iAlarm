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

//闹钟铃声名称
#define KDicSoundName000                         NSLocalizedString(@"KDicSoundName000",                          @"闹钟铃声名称-无")
#define KDicSoundName001                         NSLocalizedString(@"KDicSoundName001",                          @"闹钟铃声名称-001")
#define KDicSoundName002                         NSLocalizedString(@"KDicSoundName002",                          @"闹钟铃声名称-002")
#define KDicSoundName003                         NSLocalizedString(@"KDicSoundName003",                          @"闹钟铃声名称-003")
#define KDicSoundName004                         NSLocalizedString(@"KDicSoundName004",                          @"闹钟铃声名称-004")
#define KDicSoundName005                         NSLocalizedString(@"KDicSoundName005",                          @"闹钟铃声名称-005")
#define KDicSoundName006                         NSLocalizedString(@"KDicSoundName006",                          @"闹钟铃声名称-006")
#define KDicSoundName007                         NSLocalizedString(@"KDicSoundName007",                          @"闹钟铃声名称-007")
#define KDicSoundName008                         NSLocalizedString(@"KDicSoundName008",                          @"闹钟铃声名称-008")
#define KDicSoundName009                         NSLocalizedString(@"KDicSoundName009",                          @"闹钟铃声名称-009")
#define KDicSoundName010                         NSLocalizedString(@"KDicSoundName010",                          @"闹钟铃声名称-010")
#define KDicSoundName011                         NSLocalizedString(@"KDicSoundName011",                          @"闹钟铃声名称-011")
#define KDicSoundName012                         NSLocalizedString(@"KDicSoundName012",                          @"闹钟铃声名称-012")
#define KDicSoundName013                         NSLocalizedString(@"KDicSoundName013",                          @"闹钟铃声名称-013")
#define KDicSoundName014                         NSLocalizedString(@"KDicSoundName014",                          @"闹钟铃声名称-014")
#define KDicSoundName015                         NSLocalizedString(@"KDicSoundName015",                          @"闹钟铃声名称-015")
#define KDicSoundName016                         NSLocalizedString(@"KDicSoundName016",                          @"闹钟铃声名称-016")
#define KDicSoundName017                         NSLocalizedString(@"KDicSoundName017",                          @"闹钟铃声名称-017")
#define KDicSoundName018                         NSLocalizedString(@"KDicSoundName018",                          @"闹钟铃声名称-018")
#define KDicSoundName019                         NSLocalizedString(@"KDicSoundName019",                          @"闹钟铃声名称-019")
#define KDicSoundName020                         NSLocalizedString(@"KDicSoundName020",                          @"闹钟铃声名称-020")
#define KDicSoundName021                         NSLocalizedString(@"KDicSoundName021",                          @"闹钟铃声名称-021")
#define KDicSoundName022                         NSLocalizedString(@"KDicSoundName022",                          @"闹钟铃声名称-022")
#define KDicSoundName023                         NSLocalizedString(@"KDicSoundName023",                          @"闹钟铃声名称-023")
#define KDicSoundName024                         NSLocalizedString(@"KDicSoundName024",                          @"闹钟铃声名称-024")
#define KDicSoundName025                         NSLocalizedString(@"KDicSoundName025",                          @"闹钟铃声名称-025")
#define KDicSoundName026                         NSLocalizedString(@"KDicSoundName026",                          @"闹钟铃声名称-026")
#define KDicSoundName027                         NSLocalizedString(@"KDicSoundName027",                          @"闹钟铃声名称-027")
#define KDicSoundName028                         NSLocalizedString(@"KDicSoundName028",                          @"闹钟铃声名称-028")
#define KDicSoundName029                         NSLocalizedString(@"KDicSoundName029",                          @"闹钟铃声名称-029")
#define KDicSoundName030                         NSLocalizedString(@"KDicSoundName030",                          @"闹钟铃声名称-030")
#define KDicSoundName031                         NSLocalizedString(@"KDicSoundName031",                          @"闹钟铃声名称-031")
#define KDicSoundName032                         NSLocalizedString(@"KDicSoundName032",                          @"闹钟铃声名称-032")
#define KDicSoundName033                         NSLocalizedString(@"KDicSoundName033",                          @"闹钟铃声名称-033")
#define KDicSoundName034                         NSLocalizedString(@"KDicSoundName034",                          @"闹钟铃声名称-034")
#define KDicSoundName035                         NSLocalizedString(@"KDicSoundName035",                          @"闹钟铃声名称-035")
#define KDicSoundName036                         NSLocalizedString(@"KDicSoundName036",                          @"闹钟铃声名称-036")
#define KDicSoundName037                         NSLocalizedString(@"KDicSoundName037",                          @"闹钟铃声名称-037")
#define KDicSoundName038                         NSLocalizedString(@"KDicSoundName038",                          @"闹钟铃声名称-038")
#define KDicSoundName039                         NSLocalizedString(@"KDicSoundName039",                          @"闹钟铃声名称-039")
#define KDicSoundName040                         NSLocalizedString(@"KDicSoundName040",                          @"闹钟铃声名称-040")
#define KDicSoundName041                         NSLocalizedString(@"KDicSoundName041",                          @"闹钟铃声名称-041")
#define KDicSoundName042                         NSLocalizedString(@"KDicSoundName042",                          @"闹钟铃声名称-042")
#define KDicSoundName043                         NSLocalizedString(@"KDicSoundName043",                          @"闹钟铃声名称-043")
#define KDicSoundName044                         NSLocalizedString(@"KDicSoundName044",                          @"闹钟铃声名称-044")
#define KDicSoundName045                         NSLocalizedString(@"KDicSoundName045",                          @"闹钟铃声名称-045")
#define KDicSoundName046                         NSLocalizedString(@"KDicSoundName046",                          @"闹钟铃声名称-046")
#define KDicSoundName047                         NSLocalizedString(@"KDicSoundName047",                          @"闹钟铃声名称-047")
#define KDicSoundName048                         NSLocalizedString(@"KDicSoundName048",                          @"闹钟铃声名称-048")

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
#define KTitleTest                                 NSLocalizedString(@"KTitleTest",                              @"测试")
#define KTitleClear                                NSLocalizedString(@"KTitleClear",                             @"清除")
#define KTitleCancel                               NSLocalizedString(@"KTitleCancel",                            @"取消")
#define KTitleSearch                               NSLocalizedString(@"KTitleSearch",                            @"搜索")
#define KTitleLaunch                               NSLocalizedString(@"KTitleLaunch",                            @"启动")

#define KTextDistanceLessThan0_1Km                 NSLocalizedString(@"KTextDistanceLessThan0_1Km",              @"距离当前位置:少于0.1公里")
#define KTextWhyTimeSwitch                         NSLocalizedString(@"KTextWhyTimeSwitch",                      @"为什么要实用定时启动的描述")
#define KTextWaringRadiusTooSmall                  NSLocalizedString(@"KTextWaringRadiusTooSmall",               @"闹钟半径太小的警告")
#define KTextWaringNexttimeAlarm                   NSLocalizedString(@"KTextWaringNexttimeAlarm",                @"下一次提醒的警告")
#define KTextNotificationLaunchAlarm               NSLocalizedString(@"KTextNotificationLaunchAlarm",            @"启动位置闹钟的通知")
#define KTextAlarmHasLaunched                      NSLocalizedString(@"KTextAlarmHasLaunched",                   @"已启动！")
#define KTextWhyCanNotAutoLaunch                   NSLocalizedString(@"KTextWhyCanNotAutoLaunch",                @"不能自动启动的原因")

