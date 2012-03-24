//
//  YCCalloutBar.h
//  TestBgTask
//
//  Created by li shiyong on 11-3-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YCCalloutBar : UIView {
	
	UIImageView *shadowLeft;
	UIImageView *shadowRight;
	UIImageView *shadowMiddle1;
	UIImageView *shadowMiddle2;
	
	NSArray *buttons;
	UIImageView *arrowView;
}

@property(nonatomic,retain,readonly) UIImageView *shadowLeft;
@property(nonatomic,retain,readonly) UIImageView *shadowRight;
@property(nonatomic,retain,readonly) UIImageView *shadowMiddle1;
@property(nonatomic,retain,readonly) UIImageView *shadowMiddle2;

@property(nonatomic,retain,readonly) NSArray *buttons;
@property(nonatomic,retain,readonly) UIImageView *arrowView;

//通过按钮初title或image始化bar，没有：NSNull。只为bar上的按钮绑定 UIControlEventTouchUpInside 
- (id)initWithButtonsTitle:(NSArray*)buttonsTitle buttonsImage:(NSArray*)buttonsImage targets:(NSArray*)targets actions:(NSArray*)actions 
			  arrowPointer:(CGPoint)arrowPointer fromSuperView:(UIView*)superView;

@end
