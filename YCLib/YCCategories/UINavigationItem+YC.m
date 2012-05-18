//
//  NSString.m
//  iAlarm
//
//  Created by li shiyong on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationItem+YC.h"
#import <QuartzCore/QuartzCore.h>



@implementation UINavigationItem (YC)

- (void)setTitleView:(UIView*)theView animated:(BOOL)animated{
	if (animated) 
	{
		
		
		CATransition *animation = [CATransition animation];    
		[animation setDuration:0.5];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
		[animation setType:kCATransitionFade];
		[animation setFillMode:kCAFillModeForwards];
		[animation setRemovedOnCompletion:YES];
		
		UIView *superView = [self.titleView superview];
		
		self.titleView = theView;
		
		if(superView == nil) //self.titleView == nil 没取到superView。在这里重新取一次
			superView = [self.titleView superview];
		
		[[superView layer] addAnimation:animation forKey:@"animatedSetTitleView"];
	}else {
		self.titleView = theView; 
	}
}

@end
