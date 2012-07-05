//
//  YCImageButton.h
//  iAlarm
//
//  Created by li shiyong on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  不可拉伸图片背景的按钮

#import <UIKit/UIKit.h>

@interface YCFixedImageButton : UIButton{
    @private
    UIImage *_image;                 
    UIImage *_highlightedImage;
    CGFloat _imageCornerRadius;
    
    @package
    UIImageView *_newBackgroundView; //因为需要得到背景视图的指针，来指定拉伸属性，所以重新做背景。
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage imageCornerRadius:(CGFloat)imageCornerRadius;
- (id)initWithCoder:(NSCoder *)aDecoder image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage imageCornerRadius:(CGFloat)imageCornerRadius;

@end
