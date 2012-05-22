//
//  UIAlertView+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIAlertView+YC.h"

@implementation UIAlertView (YC)

- (void)showWaitUntilBecomeKeyWindow:(UIWindow*)waitingWindow afterDelay:(NSTimeInterval)delay{
    
    [self startOngoingSendingMessageWithTimeInterval:0.1];
    while (!waitingWindow.isKeyWindow || UIApplicationStateActive != [UIApplication sharedApplication].applicationState) 
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [self stopOngoingSendingMessage];
    
    
    [self performBlock:^{
        if (waitingWindow.isKeyWindow && UIApplicationStateActive == [UIApplication sharedApplication].applicationState){
            [self show];
        }else{
            //递归
            [self performSelector:@selector(showWaitUntilBecomeKeyWindow:afterDelay:) withObject:waitingWindow withDouble:delay afterDelay:0.0];
        }
    } afterDelay:delay];
    
}

@end
