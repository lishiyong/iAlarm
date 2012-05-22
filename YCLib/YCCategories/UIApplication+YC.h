//
//  UIApplication-YC.h
//  iAlarm
//
//  Created by li shiyong on 11-3-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIApplication (YC)


@property (nonatomic,readonly) NSString* documentsDirectory;     // ~ Documents
@property (nonatomic,readonly) NSString* libraryDirectory;       // ~ Library
@property (nonatomic,readonly) NSString* applicationDirectory;   // ~ 


@property (nonatomic,readonly) NSDate *applicationDidFinishLaunchingTime;                       //程序启动的时间
@property (nonatomic,readonly) NSTimeInterval applicationDidFinishLaunchineTimeElapsing;        //程序启动后度过的时间
@property (nonatomic,readonly) NSInteger applicationDidFinishLaunchNumber;                      //系统完成启动的次数
@property (nonatomic,readonly) NSInteger applicationDidBecomeActiveNumber;                      //进入到前台的次数

//重要：程序启动后马上要注册，上面基于通知的属性才有效
- (void)registerNotifications;
- (void)unRegisterNotifications;

 
@end
