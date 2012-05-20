//
//  UIViewController+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+YC.h"

@implementation UIViewController (YC)

- (BOOL)isViewAppeared{
    if (![self isViewLoaded]) return NO;
    
    if (self.view.superview && self.view.window) 
        return YES;
    
    return NO;
}

@end
