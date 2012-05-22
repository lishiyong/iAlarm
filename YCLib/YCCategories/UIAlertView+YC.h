//
//  UIAlertView+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"
#import <UIKit/UIKit.h>

@interface UIAlertView (YC)

/**
 延时显示。
 如果不是关键窗口或应用程序对象的状态不等于UIApplicationStateActive，那么就一直等待到符合条件后在延时显示。
 **/
- (void)showWaitUntilBecomeKeyWindow:(UIWindow*)waitingWindow afterDelay:(NSTimeInterval)delay;

@end
