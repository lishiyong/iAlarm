//
//  YCPageCulButtonItem.m
//  iAlarm
//
//  Created by li shiyong on 11-2-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCBarButtonItem.h"
#import "YCPageCurlButtonItem.h"


@implementation YCPageCurlButtonItem

/*
- (id) init{
	CGRect theFrame = CGRectMake(0, 0, 34, 30);
	UIImage *theNormalImage = [UIImage imageNamed:@"UIButtonBarPageCurlDefault.png"];
	UIImage *theHighlightedImage = [UIImage imageNamed:@"UIButtonBarPageCurlSelectedDown.png"];
	UIImage *theStyleDoneImage = [UIImage imageNamed:@"UIButtonBarPageCurlSelected.png"];
	
	return [super initWithFrame:theFrame normalImage:theNormalImage highlightedImage:theHighlightedImage styleDoneImage:theStyleDoneImage];
}
 */

-(id)initWithFrame:(CGRect)theFrame{
	UIImage *theNormalImage = [UIImage imageNamed:@"UIButtonBarPageCurlDefault.png"];
	UIImage *theHighlightedImage = [UIImage imageNamed:@"UIButtonBarPageCurlSelectedDown.png"];
	UIImage *theStyleDoneImage = [UIImage imageNamed:@"UIButtonBarPageCurlSelected.png"];
	self = [super initWithFrame:theFrame normalImage:theNormalImage highlightedImage:theHighlightedImage styleDoneImage:theStyleDoneImage];
	if (self) {
		self.style = UIBarButtonItemStyleBordered;
	}
	
	return 	self;
}


@end
