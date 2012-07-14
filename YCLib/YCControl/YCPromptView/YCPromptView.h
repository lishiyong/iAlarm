//
//  YCPromptView.h
//  iAlarm
//
//  Created by li shiyong on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    YCPromptViewStatusWaiting = 0,   //等待状态     
    YCPromptViewStatusOK,            //成功，√图标    
	YCPromptViewStatusFailture,      //失败，x图标     
    YCPromptViewStatusWarn           //警告，!图标
};

typedef NSUInteger YCPromptViewStatus;

@interface YCPromptView : UIControl <UIGestureRecognizerDelegate>{
    UIWindow *_window;
    UIView *_iconView;
    UILabel *_textLabel;
}

@property (nonatomic) BOOL dismissByTouch; //是否点击后消失
@property (nonatomic) YCPromptViewStatus promptViewStatus;
@property (nonatomic, copy) NSString *text;
- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end
