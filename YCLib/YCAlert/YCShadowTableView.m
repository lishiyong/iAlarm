//
//  YCTableView.m
//  TestAlertView
//
//  Created by li shiyong on 11-1-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCShadowTableView.h"


@implementation YCShadowTableView
@synthesize topShadowView;
@synthesize bottomShadowView;
@synthesize leftShadowView;
@synthesize rightShadowView;

#define kDefaultShadowLength   7.0

-(id)topShadowView{
	if (!topShadowView) {
		topShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCTableInnerShadowTop.png"]];
		[topShadowView.image stretchableImageWithLeftCapWidth:1.0 topCapHeight:1.0];
		topShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth     //宽自动适应
											| UIViewAutoresizingFlexibleTopMargin;//随着view顶
		topShadowView.frame = CGRectMake(0, 0, self.frame.size.width, kDefaultShadowLength);
	}
	return topShadowView;
}

-(id)bottomShadowView{
	if (!bottomShadowView) {
		bottomShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCTableInnerShadowBottom.png"]];
		bottomShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth        //宽自动适应
											   | UIViewAutoresizingFlexibleBottomMargin;//随着view底
		bottomShadowView.frame = CGRectMake(0, self.frame.size.height - kDefaultShadowLength, self.frame.size.width, kDefaultShadowLength);
	}
	return bottomShadowView;
}

-(id)leftShadowView{
	if (!leftShadowView) {
		leftShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCTableInnerShadowLeft.png"]];
		leftShadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight        //宽自动适应
											 | UIViewAutoresizingFlexibleLeftMargin;   //随着view左边
		leftShadowView.frame = CGRectMake(0, 0, kDefaultShadowLength, self.frame.size.height);
	}
	return leftShadowView;
}

-(id)rightShadowView{
	if (!rightShadowView) {
		rightShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCTableInnerShadowRight.png"]];
		rightShadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight        //高自动适应
											  | UIViewAutoresizingFlexibleRightMargin;  //随着view右边
		rightShadowView.frame = CGRectMake(self.frame.size.width - kDefaultShadowLength, 0 ,kDefaultShadowLength, self.frame.size.height );
	}
	return rightShadowView;
}


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
	if (self = [super initWithFrame:frame style:style]) {
		self.backgroundView = [[[UIView alloc] init] autorelease];
		self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundView.frame = self.bounds;
		
		//上阴影
		[self.backgroundView addSubview:self.topShadowView];
		//下阴影
		[self.backgroundView addSubview:self.bottomShadowView];
		//左阴影
		[self.backgroundView addSubview:self.leftShadowView];
		//右阴影
		[self.backgroundView addSubview:self.rightShadowView];

	}
	return self;
}

- (void)dealloc {
	[topShadowView release];
	[bottomShadowView release];
	[leftShadowView release];
	[rightShadowView release];
    [super dealloc];
}

@end
