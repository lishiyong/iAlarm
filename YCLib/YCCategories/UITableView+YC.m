//
//  UITableView+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITableView+YC.h"

@implementation UITableView (YC)

- (void)reloadDataAnimated:(BOOL)animated{
    if (animated) {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve |UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self reloadData];
        } completion:NULL];
    }else {
        [self reloadData];
    }
}

@end
