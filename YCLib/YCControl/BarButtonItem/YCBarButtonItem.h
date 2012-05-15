//
//  YCBarItem.h
//  iAlarm
//
//  Created by li shiyong on 11-1-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YCBarButtonItem : UIBarButtonItem {
	CGRect  frame;
	UIImage *normalImage;
	UIImage *highlightedImage;
	UIImage *styleDoneImage;
	
	UIButton *barButton;
}

@property(nonatomic,assign) CGRect  frame;
@property(nonatomic,retain) UIImage *normalImage;
@property(nonatomic,retain) UIImage *highlightedImage;
@property(nonatomic,retain) UIImage *styleDoneImage;
@property(nonatomic,retain,readonly) UIButton *barButton;

//指定初始化方法
-(id)initWithFrame:(CGRect)theFrame normalImage:(UIImage*)theImage highlightedImage:(UIImage*)theHighlightedImage styleDoneImage:(UIImage*)theStyleDoneImage ;


@end
