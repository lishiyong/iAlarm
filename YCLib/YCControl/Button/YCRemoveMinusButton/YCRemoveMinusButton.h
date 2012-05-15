//
//  YCRemoveMinusButton.h
//  iAlarm
//
//  Created by li shiyong on 11-2-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YCButton.h"

@interface YCRemoveMinusButton : YCButton {
	
	BOOL isOpen;  //指示是否已经打开
	
	UIImage *openImage;
	UIImage *closeImage;
	UIImage *minusImage01;
	UIImage *minusImage02;
	UIImage *minusImage03;
	UIImage *minusImage04;
	UIImage *minusImage05;
	
	NSArray *openAnimationImages; //由关闭到打开的动画
	NSArray *closeAnimationImages;
	UIImageView *animationImageView;
	
	
	
}

@property(nonatomic,assign,readonly) BOOL isOpen;

@property(nonatomic,readonly) UIImage *openImage;
@property(nonatomic,readonly) UIImage *closeImage;
@property(nonatomic,readonly) UIImage *minusImage01;
@property(nonatomic,readonly) UIImage *minusImage02;
@property(nonatomic,readonly) UIImage *minusImage03;
@property(nonatomic,readonly) UIImage *minusImage04;
@property(nonatomic,readonly) UIImage *minusImage05;

@property(nonatomic,readonly) NSArray *openAnimationImages;
@property(nonatomic,readonly) NSArray *closeAnimationImages;
@property(nonatomic,readonly) UIImageView *animationImageView;



//转换按钮状态
-(void)switchOpenStatus:(BOOL)openStatus;

@end
