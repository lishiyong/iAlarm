//
//  UIButton+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCTableViewCellButton.h"
#import "YCTexturedButton.h"
#import "UIButton+YC.h"

@implementation UIButton (YC)

+ (UIButton*)buttonWithYCType:(YCButtonType)buttonType{
    UIButton *button = nil;
    switch (buttonType) {
        case YCButtonTypeTextured:
            button = [[YCTexturedButton alloc] initWithFrame:CGRectZero];
            break;
        case YCButtonTypeTableViewCell:
            button = [[YCTableViewCellButton alloc] initWithFrame:CGRectZero];
            break;
        default:
            break;
    }
    return button;
}
@end
