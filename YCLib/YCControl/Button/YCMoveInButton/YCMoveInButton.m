//
//  YCMoveInButton.m
//  iAlarm
//
//  Created by li shiyong on 11-2-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCMoveInButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation YCMoveInButton


- (id)openHighlightedImage{
	if (openHighlightedImage == nil) {
		openHighlightedImage = [[UIImage imageNamed:@"IARemoveControlPressedRed.png"] retain];
	}
	return openHighlightedImage;
}
 

- (id)closeImage{
	if (closeImage == nil) {
		closeImage = [[UIImage imageNamed:@"IARemoveControlRedClear.png"] retain];
	}
	return closeImage;
}

- (id)openImage{
	if (openImage == nil) {
		openImage = [[UIImage imageNamed:@"IARemoveControlRed.png"] retain];
	}
	return openImage;
}

- (id)animationImage01{
	if (animationImage01 == nil) {
		animationImage01 = [[UIImage imageNamed:@"IARemoveControlRed01.png"] retain];
	}
	return animationImage01;
}

- (id)animationImage02{
	if (animationImage02 == nil) {
		animationImage02 = [[UIImage imageNamed:@"IARemoveControlRed02.png"] retain];
	}
	return animationImage02;
}

- (id)animationImage03{
	if (animationImage03 == nil) {
		animationImage03 = [[UIImage imageNamed:@"IARemoveControlRed03.png"] retain];
	}
	return animationImage03;
}

- (id)animationImage04{
	if (animationImage04 == nil) {
		animationImage04 = [[UIImage imageNamed:@"IARemoveControlRed04.png"] retain];
	}
	return animationImage04;
}

- (id)animationImage05{
	if (animationImage05 == nil) {
		animationImage05 = [[UIImage imageNamed:@"IARemoveControlRed05.png"] retain];
	}
	return animationImage05;
}

- (id)animationImage06{
	if (animationImage06 == nil) {
		animationImage06 = [[UIImage imageNamed:@"IARemoveControlRed06.png"] retain];
	}
	return animationImage06;
}

- (id)animationImage07{
	if (animationImage07 == nil) {
		animationImage07 = [[UIImage imageNamed:@"IARemoveControlRed07.png"] retain];
	}
	return animationImage07;
}

- (id)animationImage08{
	if (animationImage08 == nil) {
		animationImage08 = [[UIImage imageNamed:@"IARemoveControlRed08.png"] retain];
	}
	return animationImage08;
}

- (id)animationImage09{
	if (animationImage09 == nil) {
		animationImage09 = [[UIImage imageNamed:@"IARemoveControlRed09.png"] retain];
	}
	return animationImage09;
}

- (id)animationImage10{
	if (animationImage10 == nil) {
		animationImage10 = [[UIImage imageNamed:@"IARemoveControlRed10.png"] retain];
	}
	return animationImage10;
}

- (id)animationImage11{
	if (animationImage11 == nil) {
		animationImage11 = [[UIImage imageNamed:@"IARemoveControlRed11.png"] retain];
	}
	return animationImage11;
}

- (id)animationImage12{
	if (animationImage12 == nil) {
		animationImage12 = [[UIImage imageNamed:@"IARemoveControlRed12.png"] retain];
	}
	return animationImage12;
}

- (id)animationImage13{
	if (animationImage13 == nil) {
		animationImage13 = [[UIImage imageNamed:@"IARemoveControlRed13.png"] retain];
	}
	return animationImage13;
}


- (id)closeAnimationImages{
	if (closeAnimationImages == nil) {
		closeAnimationImages = [[NSArray arrayWithObjects:self.openImage
								 ,self.animationImage13
								 ,self.animationImage12
								 ,self.animationImage11
								 ,self.animationImage10
								 ,self.animationImage09
								 ,self.animationImage08
								 ,self.animationImage07
								 ,self.animationImage06
								 ,self.animationImage05
								 ,self.animationImage04
								 ,self.animationImage03
								 ,self.animationImage02
								 ,self.animationImage01
								 ,self.closeImage,nil] retain];
	}
	return closeAnimationImages;
}

- (id)openAnimationImages{
	if (openAnimationImages == nil) {
		openAnimationImages = [[NSArray arrayWithObjects:self.closeImage
								,self.animationImage01
								,self.animationImage02
								,self.animationImage03
								,self.animationImage04
								,self.animationImage05
								,self.animationImage06
								,self.animationImage07
								,self.animationImage08
								,self.animationImage09
								,self.animationImage10
								,self.animationImage11
								,self.animationImage12
								,self.animationImage13
								,self.openImage
								,nil] retain];
	}
	return openAnimationImages;
}

- (id)animationImageView{
	if (animationImageView == nil) {
		animationImageView = [[UIImageView alloc] initWithFrame:self.frame];
		//animationImageView.image = self.closeImage;
		animationImageView.animationImages = self.openAnimationImages;
		animationImageView.animationRepeatCount = 1;
		animationImageView.animationDuration = 0.25;
	}
	return animationImageView;
}



-(void)delaySetButtonImage{
	[self performSelectorOnMainThread:@selector(setButtonImage) withObject:nil waitUntilDone:![self.animationImageView isAnimating]];
}

-(void)setButtonImage{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setButtonImage) object:nil];
	
	[self setImage:self.openImage forState:UIControlStateNormal];
	[self setImage:self.openHighlightedImage forState:UIControlStateHighlighted];
}

- (void)setHidden:(BOOL)theHidden animated:(BOOL)animated{
	self.enabled = !theHidden;

	if (!animated) {
		
		if (!theHidden) {
			[self setImage:self.openImage forState:UIControlStateNormal];
			[self setImage:self.openHighlightedImage forState:UIControlStateHighlighted];
		}else {
			[self setImage:self.closeImage forState:UIControlStateNormal];
			[self setImage:self.closeImage forState:UIControlStateHighlighted];
		}

	}else {
		if (!theHidden){
			[self setImage:self.closeImage forState:UIControlStateNormal];
			[self setImage:self.closeImage forState:UIControlStateHighlighted];
			//播放打开动画
			self.animationImageView.animationImages = self.openAnimationImages;
			[self.animationImageView startAnimating];
			[self performSelector:@selector(delaySetButtonImage) withObject:nil afterDelay:0.2];

		}else{
			[self setImage:self.closeImage forState:UIControlStateNormal];
			[self setImage:self.closeImage forState:UIControlStateHighlighted];
			//播放关闭动画
			self.animationImageView.animationImages = self.closeAnimationImages;
			[self.animationImageView startAnimating];
		}
	}
	
}


- (id)initWithFrame:(CGRect)frame{
	if (self=[super initWithFrame:frame]) {

		[self addSubview:self.animationImageView];
		[self setImage:self.closeImage forState:UIControlStateNormal];
		[self setImage:self.closeImage forState:UIControlStateHighlighted];
		
	}
	return self;
}


- (id)init{
	return [self initWithFrame:CGRectMake(0, 0, 28, 29)];
}


- (void)dealloc 
{	
	[openHighlightedImage release];
	[openImage release];
	[closeImage release];
	[animationImage01 release];
	[animationImage02 release];
	[animationImage03 release];
	[animationImage04 release];
	[animationImage05 release];
	[animationImage06 release];
	[animationImage07 release];
	[animationImage08 release];
	[animationImage09 release];
	[animationImage10 release];
	[animationImage11 release];
	[animationImage12 release];
	[animationImage13 release];
	
	[openAnimationImages release];
	[closeAnimationImages release];
	[animationImageView release];
	
	[super dealloc];
	
}

@end
