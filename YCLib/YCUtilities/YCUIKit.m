//
//  YCUIUtility.m
//  iAlarm
//
//  Created by li shiyong on 11-3-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCUIKit.h"

CGFloat textLabelWidth(NSString*text, UIFont* font){
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)] ;
	label.font =  font;
	label.numberOfLines = 1;
	label.text = text;
	CGRect labelTextRect = [label textRectForBounds:CGRectMake(0.0, 0.0, 10000.0, 10000.0) limitedToNumberOfLines:1];
	[label release];
	
	return labelTextRect.size.width;
}

CGFloat textLabelHeigth(NSString*text, UIFont* font,CGFloat maxWidth){
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)] ;
	label.font =  font;
	//label.numberOfLines = 1;
	label.text = text;
	CGRect labelTextRect = [label textRectForBounds:CGRectMake(0.0, 0.0, maxWidth, 10000.0) limitedToNumberOfLines:0]; //0,不限制行数
	[label release];
	
	return labelTextRect.size.height;
}
