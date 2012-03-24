//
//  YCMoveInButton.h
//  iAlarm
//
//  Created by li shiyong on 11-2-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YCButton.h"

@interface YCMoveInButton : YCButton {
	
	UIImage *openHighlightedImage;
	UIImage *openImage;
	UIImage *closeImage;
	UIImage *animationImage01;
	UIImage *animationImage02;
	UIImage *animationImage03;
	UIImage *animationImage04;
	UIImage *animationImage05;
	UIImage *animationImage06;
	UIImage *animationImage07;
	UIImage *animationImage08;
	UIImage *animationImage09;
	UIImage *animationImage10;
	UIImage *animationImage11;
	UIImage *animationImage12;
	UIImage *animationImage13;
	
	NSArray *openAnimationImages; //由关闭到打开的动画
	NSArray *closeAnimationImages;
	UIImageView *animationImageView;
	
	
}

@property(nonatomic,readonly) UIImage *openHighlightedImage;
@property(nonatomic,readonly) UIImage *openImage;
@property(nonatomic,readonly) UIImage *closeImage;
@property(nonatomic,readonly) UIImage *animationImage01;
@property(nonatomic,readonly) UIImage *animationImage02;
@property(nonatomic,readonly) UIImage *animationImage03;
@property(nonatomic,readonly) UIImage *animationImage04;
@property(nonatomic,readonly) UIImage *animationImage05;
@property(nonatomic,readonly) UIImage *animationImage06;
@property(nonatomic,readonly) UIImage *animationImage07;
@property(nonatomic,readonly) UIImage *animationImage08;
@property(nonatomic,readonly) UIImage *animationImage09;
@property(nonatomic,readonly) UIImage *animationImage10;
@property(nonatomic,readonly) UIImage *animationImage11;
@property(nonatomic,readonly) UIImage *animationImage12;
@property(nonatomic,readonly) UIImage *animationImage13;

@property(nonatomic,readonly) NSArray *openAnimationImages;
@property(nonatomic,readonly) NSArray *closeAnimationImages;
@property(nonatomic,readonly) UIImageView *animationImageView;




- (void)setHidden:(BOOL)theHidden animated:(BOOL)animated;

@end
