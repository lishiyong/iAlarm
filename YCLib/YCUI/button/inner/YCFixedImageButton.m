//
//  YCImageButton.m
//  iAlarm
//
//  Created by li shiyong on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+YC.h"
#import "YCFixedImageButton.h"

@interface YCFixedImageButton(private) 
- (void)YCFixedImageButtonInit;
- (void)setBackgroundViewContentStretch;
@end

@implementation YCFixedImageButton

- (void)setBackgroundViewContentStretch{
    CGFloat x = _imageCornerRadius/self.bounds.size.width; 
    CGFloat y = _imageCornerRadius/self.bounds.size.height;
    CGFloat w = 1.0 - 2*x;
    CGFloat h = 1.0 - 2*y;
    _newBackgroundView.contentStretch = CGRectMake(x, y, w, h);
}

#pragma mark - override superclass

- (void)setBackgroundImage:(UIImage *)theImage forState:(UIControlState)state{
    
    _newBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _newBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin; //完全随按钮的大小改变
    _newBackgroundView.image = _image;
    _newBackgroundView.highlightedImage = _highlightedImage;
    [self setBackgroundViewContentStretch];
    
    [self insertSubview:_newBackgroundView atIndex:0];
    
    [super setBackgroundImage:nil forState:UIControlStateNormal];
    [super setBackgroundImage:nil forState:UIControlStateHighlighted];
    
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

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage imageCornerRadius:(CGFloat)imageCornerRadius{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame)) {
        frame = CGRectMake(0, 0, 300, 46);
    }
    self = [super initWithFrame:frame];
    if (self) {
        _image = [image retain];
        _highlightedImage = [highlightedImage retain];
        _imageCornerRadius = imageCornerRadius;
        [self YCFixedImageButtonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage imageCornerRadius:(CGFloat)imageCornerRadius{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _image = [image retain];
        _highlightedImage = [highlightedImage retain];
        _imageCornerRadius = imageCornerRadius;
        [self YCFixedImageButtonInit];
    }
    return self;
}

- (void)YCFixedImageButtonInit{
    [self setBackgroundImage:nil forState:0];
    [self setTitleColor:nil forState:0];
    [self setTitleShadowColor:nil forState:0];
}

- (void)dealloc{
    [_image release];
    [_highlightedImage release];
    [_newBackgroundView release];
    [super dealloc];
}

@end
