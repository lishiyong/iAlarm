//
//  NSString.m
//  iAlarm
//
//  Created by li shiyong on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController-YC.h"


@implementation UIViewController (YC)

const CGFloat titleImageW = 22.0;
const CGFloat titleImageH = 22.0;
const CGFloat titleViewW = 162.0; //titleView 固定宽度
const CGFloat kKj = 1.0;//title与image间的空隙

- (id)cannotLocationTitleView{
	
	//titleView 
	UIView *cannotLocationTitleView = [[[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,titleViewW,44.0)] autorelease];
	cannotLocationTitleView.backgroundColor = [UIColor clearColor];
	
	//titleLabel 靠imageView，间隔kKj
	CGRect titleLabelFrame = CGRectMake(0.0,0.0,titleViewW,44.0);
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:titleLabelFrame] autorelease];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.text = self.title;
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.minimumFontSize = 16.0;
	titleLabel.shadowColor = [UIColor darkGrayColor];
	titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	titleLabel.textAlignment = UITextAlignmentCenter;
	CGRect titleLabelRealFrame = [titleLabel textRectForBounds:titleLabelFrame limitedToNumberOfLines:1];
	if (titleLabelRealFrame.origin.x < (titleImageW + kKj)) { //如果titleLabel内容较长：加上imageView超过了TitleView的宽
		titleLabelFrame = CGRectMake(titleImageW + kKj,0.0,titleViewW,44.0);//重新安排titleLabel的frame
		titleLabel.frame = titleLabelFrame;
		titleLabel.textAlignment = UITextAlignmentLeft;//不需要居中对齐了
	}
	[cannotLocationTitleView addSubview:titleLabel];
	
	
	//imageView 在左边
	CGFloat imageViewX = (titleViewW - titleLabelRealFrame.size.width)/2 - titleImageW - kKj;
	if (imageViewX < 0.0) imageViewX = 0.0; //如果在TitleView外，拉回
	CGRect imageViewFrame = CGRectMake(imageViewX, (44.0-titleImageH)/2, titleImageW, titleImageH);
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:imageViewFrame] autorelease];
	UIImage *image = [UIImage imageNamed:@"IACannotLocation.png"];
	UIImage *imageClear = [UIImage imageNamed:@"IACannotLocationClear.png"];
	imageView.image = image;
	imageView.animationImages = [NSArray arrayWithObjects:image,image,imageClear,nil];
	imageView.animationDuration = 1.5;
	[imageView startAnimating];
	[cannotLocationTitleView addSubview:imageView];
		
	
	
	return cannotLocationTitleView;
}

const CGFloat detailTitleViewW = 206.0; // 固定宽度
- (UIView*)detailTitleViewWithContent:(NSString*)content{
	
	CGRect titleLabelFrame = CGRectMake(0.0,0.0,detailTitleViewW,44.0);
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:titleLabelFrame] autorelease];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor colorWithRed:18.0/256.0 green:35.0/256.0 blue:70.0/256.0 alpha:1.0];
	titleLabel.text = content;
	titleLabel.font = [UIFont systemFontOfSize:14.0];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.minimumFontSize = 10.0;
	titleLabel.shadowColor = [UIColor lightTextColor];
	titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
	titleLabel.textAlignment = UITextAlignmentCenter;

	return titleLabel;
}

@end
