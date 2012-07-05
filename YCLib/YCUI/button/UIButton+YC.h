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
    YCButtonTypeGlass,        //未实现
    YCButtonTypePopover,      //未实现
    YCButtonTypeTableViewCell 
} YCButtonType;


@interface UIButton (YC)

+ (UIButton*)buttonWithYCType:(YCButtonType)buttonType;

@end
