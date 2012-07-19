//
//  YCCheckMarkCell.h
//  iAlarm
//
//  Created by li shiyong on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  复选cell

#import <UIKit/UIKit.h>

enum YCCheckMarkType {
    YCCheckMarkTypeRight = 0,
    YCCheckMarkTypeLeft
};

typedef NSUInteger YCCheckMarkType;

@interface YCCheckMarkCell : UITableViewCell{
    YCCheckMarkType _checkMarkType;
    BOOL _isCheckMark;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier checkMarkType:(YCCheckMarkType)checkMarkType;
@property (nonatomic) BOOL checkmark;
@property (nonatomic) BOOL changeWhenSelected; //选中时候是否改变checkmark状态

@end
