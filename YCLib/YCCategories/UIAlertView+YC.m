//
//  UIAlertView+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIAlertView+YC.h"

@implementation UIAlertView (YC)


- (void)registerNotifications {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handleApplicationDidEnterBackground:)
							   name: UIApplicationDidEnterBackgroundNotification
							 object: nil];
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
}

- (void)showWaitUntilBecomeKeyWindow:(UIWindow*)waitingWindow afterDelay:(NSTimeInterval)delay{    
    
    if (waitingWindow == nil) {
        [self show];
        return;
    }
    
    //
    [self unRegisterNotifications];
    [self registerNotifications];
    
    //
    NSDate *date = [NSDate date];
    while ((!waitingWindow.isKeyWindow || UIApplicationStateInactive == [UIApplication sharedApplication].applicationState)) 
    {
        if (fabs([date timeIntervalSinceNow]) > 30.0 ) //最长等30秒
            return;
        
        if (UIApplicationStateBackground  == [UIApplication sharedApplication].applicationState) //都退到后台了
            return;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
    if (UIApplicationStateBackground  == [UIApplication sharedApplication].applicationState) //都退到后台了
        return;
    
    //
    [self performBlock:^{
        if (UIApplicationStateBackground  == [UIApplication sharedApplication].applicationState) //都退到后台了
            return;
        
        
        if (waitingWindow.isKeyWindow && UIApplicationStateActive == [UIApplication sharedApplication].applicationState){
            [self show];
        }else{
            //递归
            [self performSelector:@selector(showWaitUntilBecomeKeyWindow:afterDelay:) withObject:waitingWindow withDouble:delay afterDelay:0.1];
        }
    } afterDelay:delay];
    
    
}



- (void)handleApplicationDidEnterBackground:(id)notification{
    [NSObject cancelPreviousPerformBlockRequestsWithTarget:self];    
}



@end
