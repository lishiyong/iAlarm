//
//  YCTableViewCellButton.m
//  iAlarm
//
//  Created by li shiyong on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCTableViewCellButton.h"

@implementation YCTableViewCellButton

#pragma mark - init

- (void)YCTableViewCellButtonInit{
    //没有文字阴影
    self.titleLabel.shadowOffset = (CGSize){0.0,0.0}; 
    //缺省：17号字
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
}

-(id)initWithFrame:(CGRect)theFrame{
    UIImage *image = [UIImage imageNamed:@"YCTableViewCellButton.png"];
    UIImage *highlightedImage = [UIImage imageNamed:@"YCTableViewCellPressedButton.png"];
    self = [super initWithFrame:theFrame image:image highlightedImage:highlightedImage imageCornerRadius:8.0];
                                                                                       //YCTexturedButton.png的圆角像素是8
    if (self) {
        [self YCTableViewCellButtonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    UIImage *image = [UIImage imageNamed:@"YCTableViewCellButton.png"];
    UIImage *highlightedImage = [UIImage imageNamed:@"YCTableViewCellPressedButton.png"];
    self = [super initWithCoder:aDecoder image:image highlightedImage:highlightedImage imageCornerRadius:8.0];
                                                                                        //YCTexturedButton.png的圆角像素是8
    if (self) {
        [self YCTableViewCellButtonInit];
    }
    return self;
}

#pragma mark - override superclass

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    UIColor *titleColor = [UIColor darkTextColor]; //黑色的文字
    UIColor *hTitleColor = [UIColor whiteColor];//高亮：白字
    [super setTitleColor:titleColor forState:UIControlStateNormal];
    [super setTitleColor:hTitleColor forState:UIControlStateHighlighted];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state{
    UIColor *shadowColor = [UIColor clearColor];//没有阴影
    UIColor *hShadowColor = [UIColor clearColor];
    [super setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [super setTitleShadowColor:hShadowColor forState:UIControlStateHighlighted];
}


@end
