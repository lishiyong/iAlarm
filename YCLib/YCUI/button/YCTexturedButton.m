//
//  YCTexturedButton.m
//  iAlarm
//
//  Created by li shiyong on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+YC.h"
#import "YCTexturedButton.h"

@interface YCTexturedButton(private) 
- (void)otherInit;
- (void)setBackgroundViewContentStretch;
@end

@implementation YCTexturedButton

- (void)setBackgroundViewContentStretch{
    CGFloat x = 8.0/self.bounds.size.width; //YCTexturedButton.png的圆角像素是8
    CGFloat y = 8.0/self.bounds.size.height;
    CGFloat w = 1.0 - 2*x;
    CGFloat h = 1.0 - 2*y;
    _newBackgroundView.contentStretch = CGRectMake(x, y, w, h);
}

#pragma mark - override superclass

- (void)setBackgroundImage:(UIImage *)theImage forState:(UIControlState)state{
    UIImage *image                 = [UIImage imageNamed:@"YCTexturedButton.png"];
    UIImage *imagePressed          = [UIImage imageNamed:@"YCTexturedPressedButton.png"];
    
    _newBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _newBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin; //完全随按钮的大小改变
    _newBackgroundView.image = image;
    _newBackgroundView.highlightedImage = imagePressed;
    [self setBackgroundViewContentStretch];
    
    [self insertSubview:_newBackgroundView atIndex:0];
    
    [super setBackgroundImage:nil forState:UIControlStateNormal];
    [super setBackgroundImage:nil forState:UIControlStateHighlighted];

}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    UIColor *titleColor = [UIColor texturedButtonGradientColor];
    [super setTitleColor:titleColor forState:UIControlStateNormal];
    [super setTitleColor:titleColor forState:UIControlStateHighlighted];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state{
    [super setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateNormal];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [_newBackgroundView setHighlighted:highlighted];
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    [self setBackgroundViewContentStretch];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setBackgroundViewContentStretch];
}

#pragma mark - init and memery manager

-(id)initWithFrame:(CGRect)theFrame{
    self = [super initWithFrame:theFrame];
    if (self) {
        [self otherInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self otherInit];
    }
    return self;
}

- (void)otherInit{
    [self setBackgroundImage:nil forState:0];
    [self setTitleColor:nil forState:0];
    [self setTitleShadowColor:nil forState:0];
}

- (void)dealloc{
    [_newBackgroundView release];
    [super dealloc];
}


@end
