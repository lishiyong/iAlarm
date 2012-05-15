//
//  YCMaskView.m
//  iAlarm
//
//  Created by li shiyong on 11-3-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCMaskView.h"


@implementation YCMaskView

- (id)init{
	CGRect theFrame = [UIScreen mainScreen].applicationFrame;
	theFrame = CGRectMake(0.0, 0.0+20, theFrame.size.width, theFrame.size.height-20.0);
	
	if (self = [super initWithFrame:theFrame]) {
		self.backgroundColor = [UIColor clearColor];
		self.alpha = 1.0;
		super.hidden = YES; //这个属性被重写了
		acView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		
		/////////////////////////////
		//居中指示器
		CGFloat acViewWidth = acView.frame.size.width; 
		CGFloat acViewHeight = acView.frame.size.height;
		CGFloat acViewX = theFrame.size.width/2 - acViewWidth/2 ;
		CGFloat acViewY = theFrame.size.height/2 - acViewHeight/2;
		acView.frame = CGRectMake(acViewX, acViewY, acViewWidth, acViewHeight);
		/////////////////////////////
		[self addSubview:acView];
		acView.hidesWhenStopped = YES;
		[acView startAnimating];
		
		
		alertView = [[UIAlertView alloc] initWithTitle:nil
											   message:nil 
											  delegate:nil
									 cancelButtonTitle:nil 
									 otherButtonTitles:nil];
		
		alertView.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
		alertView.hidden = YES;
	}
	return self;
}

- (id)initWithFrame:(CGRect)theFrame {
    
	/*
    self = [super initWithFrame:theFrame];
    if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		self.alpha = 1.0;
		super.hidden = YES; //这个属性被重写了
		UIActivityIndicatorView *acView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		
		/////////////////////////////
		//居中指示器
		CGFloat acViewWidth = acView.frame.size.width; 
		CGFloat acViewHeight = acView.frame.size.height;
		CGFloat acViewX = theFrame.size.width/2 - acViewWidth/2 ;
		CGFloat acViewY = theFrame.size.height/2 - acViewHeight/2;
		acView.frame = CGRectMake(acViewX, acViewY, acViewWidth, acViewHeight);
		/////////////////////////////
		[self addSubview:acView];
		acView.hidesWhenStopped = YES;
		[acView startAnimating];
		
		
		alertView = [[UIAlertView alloc] initWithTitle:nil
														message:nil 
													   delegate:nil
											  cancelButtonTitle:nil 
											  otherButtonTitles:nil];
		
		alertView.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
		alertView.hidden = YES;
		
    }
    return self;
	 */
	return [self init];
}


- (void)setHidden:(BOOL)theHidden{
	
	super.hidden = theHidden;
	if (theHidden) {
		[self removeFromSuperview];
		[alertView dismissWithClickedButtonIndex:0 animated:NO];
	}else {
		UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
		[mainWindow addSubview:self];
		[alertView show];
		[acView startAnimating];
	}

}


- (void)dealloc {
	//[self setHidden:YES];
	
	[alertView release];
	[acView release];
    [super dealloc];
}


@end
