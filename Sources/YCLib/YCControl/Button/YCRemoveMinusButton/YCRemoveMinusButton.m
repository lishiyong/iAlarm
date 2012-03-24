//
//  YCRemoveMinusButton.m
//  iAlarm
//
//  Created by li shiyong on 11-2-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCRemoveMinusButton.h"


@implementation YCRemoveMinusButton
@synthesize isOpen;

- (id)closeImage{
	if (closeImage == nil) {
		closeImage = [[UIImage imageNamed:@"IARemoveControlMinus.png"] retain];
	}
	return closeImage;
}

- (id)openImage{
	if (openImage == nil) {
		openImage = [[UIImage imageNamed:@"IARemoveControlVerticalLine.png"] retain];
	}
	return openImage;
}

- (id)minusImage01{
	if (minusImage01 == nil) {
		minusImage01 = [[UIImage imageNamed:@"IARemoveControlMinus01.png"] retain];
	}
	return minusImage01;
}

- (id)minusImage02{
	if (minusImage02 == nil) {
		minusImage02 = [[UIImage imageNamed:@"IARemoveControlMinus02.png"] retain];
	}
	return minusImage02;
}

- (id)minusImage03{
	if (minusImage03 == nil) {
		minusImage03 = [[UIImage imageNamed:@"IARemoveControlMinus03.png"] retain];
	}
	return minusImage03;
}

- (id)minusImage04{
	if (minusImage04 == nil) {
		minusImage04 = [[UIImage imageNamed:@"IARemoveControlMinus04.png"] retain];
	}
	return minusImage04;
}

- (id)minusImage05{
	if (minusImage05 == nil) {
		minusImage05 = [[UIImage imageNamed:@"IARemoveControlMinus05.png"] retain];
	}
	return minusImage05;
}




- (id)closeAnimationImages{
	if (closeAnimationImages == nil) {
		closeAnimationImages = [[NSArray arrayWithObjects:self.openImage
								 ,self.minusImage05
								 ,self.minusImage04
								 ,self.minusImage03
								 ,self.minusImage02
								 ,self.minusImage01
								 ,self.closeImage,nil] retain];
	}
	return closeAnimationImages;
}

- (id)openAnimationImages{
	if (openAnimationImages == nil) {
		openAnimationImages = [[NSArray arrayWithObjects:self.closeImage
								,self.minusImage01
								,self.minusImage02
								,self.minusImage03
								,self.minusImage04
								,self.minusImage05
								,self.openImage
								,nil] retain];
	}
	return openAnimationImages;
}

- (id)animationImageView{
	if (animationImageView == nil) {
		animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 29, 31)];
		animationImageView.animationImages = self.openAnimationImages;
		animationImageView.animationRepeatCount = 1;
		animationImageView.animationDuration = 0.15;
	}
	return animationImageView;
}



- (id)init{
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 29, 31)]) {
		[self addSubview:self.animationImageView];
		[self setImage:self.closeImage forState:UIControlStateNormal];
	}
	
	return self;
	
}

- (id)initWithFrame:(CGRect)frame{
	return [self init];
}

//转换按钮状态
-(void)switchOpenStatus:(BOOL)openStatus{
	
	isOpen = openStatus;
	
	if (self.isOpen) {
		//播放打开动画
		self.animationImageView.animationImages = self.openAnimationImages;
		[self.animationImageView startAnimating];
		[self setImage:self.openImage forState:UIControlStateNormal];
	}else {
		//播放关闭动画
		self.animationImageView.animationImages = self.closeAnimationImages;
		[self.animationImageView startAnimating];
		[self setImage:self.closeImage forState:UIControlStateNormal];

	}
	
	
}


NSArray *openAnimationImages; //由关闭到打开的动画
NSArray *closeAnimationImages;




- (void)dealloc 
{
	[openImage release];
	[closeImage release];
	[minusImage01 release];
	[minusImage02 release];
	[minusImage03 release];
	[minusImage04 release];
	[minusImage05 release];
	
	[openAnimationImages release];
	[closeAnimationImages release];
	[animationImageView release];
	[super dealloc];
	
}


@end
