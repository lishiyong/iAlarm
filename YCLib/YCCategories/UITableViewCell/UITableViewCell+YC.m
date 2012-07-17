//
//  UITableViewCell+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCell+YC.h"

@implementation UITableViewCell (YC)

- (void)setCellYCType:(YCTableViewCellType)type{
    UIImage *blueCheck = [UIImage imageNamed:@"YCPreferencesBlueCheck.png"];
    UIImage *whiteCheck = [UIImage imageNamed:@"YCPreferencesWhiteCheck.png"];
    self.imageView.image = blueCheck;
    self.imageView.highlightedImage = whiteCheck;
    self.imageView.alpha = 0.0;
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)setCheckmark:(BOOL)checkmark{
    if (checkmark) {
        if (self.imageView.image == nil) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            self.imageView.alpha = 1.0;
        }
    }else {
        if (self.imageView.image == nil) {
            self.accessoryType = UITableViewCellAccessoryNone;
        }else {
            self.imageView.alpha = 0.0;
        }
    }
}

- (BOOL)checkmark{
    if (self.imageView.image == nil) {
        return (self.accessoryType == UITableViewCellAccessoryCheckmark);
    }else {
        return (self.imageView.alpha == 1.0);
    }
}

@end
