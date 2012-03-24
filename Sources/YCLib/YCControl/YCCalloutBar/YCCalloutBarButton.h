//
//  YCCalloutBarButton.h
//  TestBgTask
//
//  Created by li shiyong on 11-3-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    YCCalloutBarButtonTypeLeft = 0,        
	YCCalloutBarButtonTypeMiddle,             
    YCCalloutBarButtonTypeRight,
	YCCalloutBarButtonTypeSigle
};
typedef NSUInteger YCCalloutBarButtonType;

extern const UIEdgeInsets kCalloutBarLeftButtonInset;//button留出的空
extern const UIEdgeInsets kCalloutBarMiddleButtonInset;
extern const UIEdgeInsets kCalloutBarRightButtonInset;


@interface YCCalloutBarButton : UIButton {
	UIButton *arrowButton;
	YCCalloutBarButtonType barButtontype;
	
	//UIImageView *appendViewContainer;
	UIButton *appendViewContainer;
}

@property(nonatomic,retain,readonly) UIButton *arrowButton;
@property(nonatomic,assign,readonly) YCCalloutBarButtonType barButtontype;
@property(nonatomic,retain,readonly) UIButton *appendViewContainer;

- (id)initWithFrame:(CGRect)frame barButtontype:(YCCalloutBarButtonType)theBarButtontype title:(NSString*)title image:(UIImage*)image 
	 arrowButtonFrame:(CGRect)arrowButtonFrame fromSuperView:(UIView*)superView;

//产生arrowButton
- (void)genArrowButtonWithFrame:(CGRect)arrowButtonFrame fromSuperView:(UIView*)superView;

//
- (void)appendView:(UIView*)view;

@end
