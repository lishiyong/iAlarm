//
//  YCCalloutBarButton.m
//  TestBgTask
//
//  Created by li shiyong on 11-3-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "YCCalloutBarButton.h"

//button留出的空
const UIEdgeInsets kCalloutBarLeftButtonInset   = {0.0, 20.0, 0.0, 16.0};
const UIEdgeInsets kCalloutBarMiddleButtonInset = {0.0, 18.0, 0.0, 16.0}; //分隔线＝ 2
const UIEdgeInsets kCalloutBarRightButtonInset  = {0.0, 18.0, 0.0, 20.0};  


/*
const UIEdgeInsets kCalloutBarLeftButtonInset   = {0.0, 12.0, 0.0, 8.0};//button留出的空
const UIEdgeInsets kCalloutBarMiddleButtonInset = {0.0, 8.0, 0.0, 6.0};
const UIEdgeInsets kCalloutBarRightButtonInset  = {0.0, 8.0, 0.0, 10.0};
*/

@implementation YCCalloutBarButton
@synthesize barButtontype;

- (id)arrowButton{
	if (arrowButton == nil) {
		arrowButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		arrowButton.backgroundColor = [UIColor clearColor];
		
		//[arrowButton setBackgroundImage:[UIImage imageNamed:@"YCCalloutBarArrowBottom.png"] forState:UIControlStateNormal];
		[arrowButton setBackgroundImage:[UIImage imageNamed:@"YCCalloutBarArrowBottomHi.png"] forState:UIControlStateHighlighted];
		[arrowButton setBackgroundImage:[UIImage imageNamed:@"YCCalloutBarArrowBottomDisabled.png"] forState:UIControlStateDisabled];
	}
	
	return arrowButton;
	
}

- (id)appendViewContainer{
	
	if (appendViewContainer == nil) {                                      //-2为了挡住后面的背景
		appendViewContainer = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
		[appendViewContainer addTarget:self action:@selector(appendViewContainerPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
	return appendViewContainer;
}


- (void)animateSetAppendViewHidden:(BOOL)hidden{
	
	CATransition *animation = [CATransition animation];  
	[animation setDuration:0.4];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	[animation setType:kCATransitionFade];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:YES];
	
	if (hidden)
		[self.appendViewContainer removeFromSuperview];
	else 
		[self addSubview:self.appendViewContainer];
	
	[[self layer] addAnimation:animation forKey:@"animateSetAppendView"];
}


- (void)appendViewContainerPressed:(id)sender{
	//[self.appendViewContainer removeFromSuperview];
	[self animateSetAppendViewHidden:YES];
}



- (void)appendView:(UIView*)view{
	
	[self.appendViewContainer removeFromSuperview];
	if (view) {
		
		view.userInteractionEnabled = NO;
		
		//view的居中
		CGFloat viewX = (self.appendViewContainer.frame.size.width - view.frame.size.width)/2;
		CGFloat viewY = (self.appendViewContainer.frame.size.height - view.frame.size.height)/2;
		CGFloat xOffSet = (kCalloutBarLeftButtonInset.left-kCalloutBarLeftButtonInset.right)/2;
		CGFloat yOffSet = 1.0;
		
		CGRect viewFrame = CGRectMake(viewX+xOffSet, viewY+yOffSet, view.frame.size.width, view.frame.size.height);
		view.frame = viewFrame;
		[self.appendViewContainer addSubview:view];
		
		

		[self.appendViewContainer setBackgroundImage:self.currentBackgroundImage forState:UIControlStateNormal];
		[self.appendViewContainer setBackgroundImage:self.currentBackgroundImage forState:UIControlStateHighlighted];
		//[self addSubview:self.appendViewContainer];
		[self animateSetAppendViewHidden:NO];
	}
	
}

- (void)genArrowButtonWithFrame:(CGRect)arrowButtonFrame fromSuperView:(UIView*)superView{
	//把三角箭头加入到button中
	
	CGRect arrowContainerFrame = CGRectMake(0.0, self.frame.size.height, self.frame.size.width, arrowButtonFrame.size.height);
	UIView *arrowContainer = [[[UIView alloc] initWithFrame:arrowContainerFrame] autorelease];
	[self addSubview:arrowContainer];
	arrowContainer.clipsToBounds = YES;
	
	CGRect arrowRectInButton = [arrowContainer convertRect:arrowButtonFrame fromView:superView];
	self.arrowButton.frame = arrowRectInButton;
	[arrowContainer addSubview:self.arrowButton];
	
}

//////////////////////////////////////
//覆盖父类的方法，让三角箭头同时高亮或不可用
- (void)setHighlighted:(BOOL)b{
	[super setHighlighted:b];
	if (arrowButton) {
		arrowButton.highlighted = b;
	}
}

- (void)setEnabled:(BOOL)b{
	[super setEnabled:b];
	
	self.arrowButton.enabled = b;
}

//////////////////////////////////////

- (id)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame barButtontype:0 title:nil image:nil arrowButtonFrame:CGRectMake(0, 0, 0, 0) fromSuperView:nil];
}


- (id)initWithFrame:(CGRect)frame barButtontype:(YCCalloutBarButtonType)theBarButtontype title:(NSString*)title image:(UIImage*)image 
   arrowButtonFrame:(CGRect)arrowButtonFrame fromSuperView:(UIView*)superView{
	
	const CGFloat kFirstButtonLeftCap = 10.0;                                          //第一个按钮左帽
	const CGFloat kLastButtonLeftCap = 1.0;                                            //最后一个按钮左帽
	const CGFloat kSigleButtonLeftCap = 10.0;                                          //单个按钮左帽
    
	if (self = [super initWithFrame:frame]) {
		
		UIImage *bgNo = nil;
		UIImage *bgHi = nil;
		UIImage *bgDi = nil;
		
		UIEdgeInsets kCalloutBarButtonInset;
		switch (theBarButtontype) {
			case YCCalloutBarButtonTypeLeft:
				bgNo = [[UIImage imageNamed:@"YCCalloutBarLeft.png"] stretchableImageWithLeftCapWidth:kFirstButtonLeftCap topCapHeight:0.0];
				bgHi = [[UIImage imageNamed:@"YCCalloutBarLeftHi.png"] stretchableImageWithLeftCapWidth:kFirstButtonLeftCap topCapHeight:0.0];
				bgDi = [[UIImage imageNamed:@"YCCalloutBarLeftDisabled.png"] stretchableImageWithLeftCapWidth:kFirstButtonLeftCap topCapHeight:0.0];				
				kCalloutBarButtonInset = kCalloutBarLeftButtonInset;
				break;
			case YCCalloutBarButtonTypeRight:
				bgNo = [[UIImage imageNamed:@"YCCalloutBarRight.png"] stretchableImageWithLeftCapWidth:kLastButtonLeftCap topCapHeight:0.0];
				bgHi = [[UIImage imageNamed:@"YCCalloutBarRightHi.png"] stretchableImageWithLeftCapWidth:kLastButtonLeftCap topCapHeight:0.0];
				bgDi = [[UIImage imageNamed:@"YCCalloutBarRightDisabled.png"] stretchableImageWithLeftCapWidth:kLastButtonLeftCap topCapHeight:0.0];				
				kCalloutBarButtonInset = kCalloutBarRightButtonInset;
				break;
			case YCCalloutBarButtonTypeMiddle:
				bgNo = [UIImage imageNamed:@"YCCalloutBarMiddle.png"];
				bgHi = [UIImage imageNamed:@"YCCalloutBarMiddleHi.png"];
				bgDi = [UIImage imageNamed:@"YCCalloutBarMiddleDisabled.png"];
				kCalloutBarButtonInset = kCalloutBarMiddleButtonInset;
				break;
			case YCCalloutBarButtonTypeSigle:
				bgNo = [[UIImage imageNamed:@"YCCalloutBarSingle.png"] stretchableImageWithLeftCapWidth:kSigleButtonLeftCap topCapHeight:0.0];
				bgHi = [[UIImage imageNamed:@"YCCalloutBarSingleHi.png"] stretchableImageWithLeftCapWidth:kSigleButtonLeftCap topCapHeight:0.0];
				bgDi = [[UIImage imageNamed:@"YCCalloutBarSingleDisabled.png"] stretchableImageWithLeftCapWidth:kSigleButtonLeftCap topCapHeight:0.0];				
				kCalloutBarButtonInset = kCalloutBarMiddleButtonInset;
				break;
			default:
				kCalloutBarButtonInset = kCalloutBarMiddleButtonInset;
				break;
		}
		
		//透明背景色
		self.backgroundColor = [UIColor clearColor];
		
		//按钮左右留空
		self.contentEdgeInsets = kCalloutBarButtonInset;
		
		//背景图
		[self setBackgroundImage:bgNo forState:UIControlStateNormal];
		[self setBackgroundImage:bgHi forState:UIControlStateHighlighted];
		[self setBackgroundImage:bgDi forState:UIControlStateDisabled];
		
		
		//title，image，如果有image title就不显示
		if(title) 
			[self setTitle:title forState:UIControlStateNormal];
		if(image) 
			[self setImage:image forState:UIControlStateNormal];
		
		//
		self.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		self.titleLabel.shadowColor = [UIColor darkTextColor];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor colorWithRed:(205.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] forState:UIControlStateDisabled];
		
		
    }
    return self;
	
}

- (void)dealloc {
	[arrowButton release];
	[appendViewContainer release];
    [super dealloc];
}


@end
