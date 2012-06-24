//
//  ABPasteboardControl+YCBookmark.m
//  iAlarm
//
//  Created by li shiyong on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAContactManager.h"
#import "ABPasteboardControl+YCBookmark.h"

@implementation ABPasteboardControl (YCBookmark)

- (void)longPress:(UIGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateBegan ) {
        [[IAContactManager sharedManager] personImageDidPress];
    }
}

/*
- (void)abMenuControllerWillShow:(id)fp8{
    NSLog(@"abMenuControllerWillShow self = %@",[self debugDescription]);
}
- (void)abMenuControllerWillHide{
    NSLog(@"abMenuControllerWillHide self = %@",[self debugDescription]);
}
 */
- (void)menuControllerWillShow:(id)fp8{
    NSLog(@"menuControllerWillShow self = %@",[self debugDescription]);
    //[[IAContactManager sharedManager] personImageDidPress];
}



@end
