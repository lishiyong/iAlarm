//
//  UIButton+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YCButtonTypeTextured = 0,
    YCButtonTypeGlass,
    YCButtonTypePopover, 
} YCButtonType;


@interface UIButton (YC)

+ (UIButton*)buttonWithYCType:(YCButtonType)buttonType;

@end
