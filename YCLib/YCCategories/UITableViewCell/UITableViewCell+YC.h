//
//  UITableViewCell+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum YCTableViewCellType {
    YCTableViewCellTypeCanCheckDetailDisclosure = 0  //可以选择，有详细按钮
};

typedef NSUInteger YCTableViewCellType;

@interface UITableViewCell (YC)

- (void)setCellYCType:(YCTableViewCellType)type;
@property (nonatomic) BOOL checkmark;

@end
