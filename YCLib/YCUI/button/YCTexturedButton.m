//
//  YCTexturedButton.m
//  iAlarm
//
//  Created by li shiyong on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+YC.h"
#import "YCTexturedButton.h"


@implementation YCTexturedButton

#pragma mark - init

- (void)YCTexturedButtonInit{
    //文字阴影
    self.titleLabel.shadowOffset = (CGSize){0.0,1.0}; 
    //缺省：18号字
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
}

-(id)initWithFrame:(CGRect)theFrame{
    UIImage *image = [UIImage imageNamed:@"YCTexturedButton.png"];
    UIImage *highlightedImage = [UIImage imageNamed:@"YCTexturedPressedButton.png"];
    self = [super initWithFrame:theFrame image:image highlightedImage:highlightedImage imageCornerRadius:8.0];
                                                                                       //YCTexturedButton.png的圆角像素是8
    if (self) {
        [self YCTexturedButtonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    UIImage *image = [UIImage imageNamed:@"YCTexturedButton.png"];
    UIImage *highlightedImage = [UIImage imageNamed:@"YCTexturedPressedButton.png"];
    self = [super initWithCoder:aDecoder image:image highlightedImage:highlightedImage imageCornerRadius:8.0];
                                                                                    //YCTexturedButton.png的圆角像素是8
    if (self) {
        [self YCTexturedButtonInit];
    }
    return self;
}

#pragma mark - override superclass

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    UIColor *titleColor = [UIColor texturedButtonGradientColor]; //
    UIColor *hTitleColor = [UIColor texturedButtonGradientColor];//高亮：不变
    [super setTitleColor:titleColor forState:UIControlStateNormal];
    [super setTitleColor:hTitleColor forState:UIControlStateHighlighted];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state{
    UIColor *shadowColor = [UIColor colorWithWhite:1.0 alpha:0.75];//阴影颜色稍浅
    UIColor *hShadowColor = [UIColor colorWithWhite:1.0 alpha:0.75];
    [super setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [super setTitleShadowColor:hShadowColor forState:UIControlStateHighlighted];
}



@end
